# 数据库迁移与示例数据说明

本目录下的迁移脚本用于在 **新 Go 后端项目（satellite-cloud）** 中创建与旧 Django 项目等价的数据库结构，并导入一份最小示例数据。

## 文件说明

- `migrations/001_init_schema.sql`
  - 创建 `scenarios` 和 `satellites` 两张表
  - 字段与旧项目 `satellites/models.py` 保持一致
  - 包含：
    - `sensor_config` JSONB 字段
    - `created_at` / `updated_at` 字段（默认值 `NOW()`）
    - 索引：
      - `(scenario_id, sat_id)`
      - `(plane_index, sat_index_in_plane)`
    - `updated_at` 自动更新时间的触发器

- `migrations/002_seed_data.sql`
  - 基于 `starlink_shell1_36x22.json` 中的 **Scenario5** 创建一条场景记录
  - 插入 plane 1 下的前三颗卫星（`sat-1-1`、`sat-1-2`、`sat-1-3`）作为示例数据
  - 用于快速验证前后端联调（Cesium 轨道可视化等）

> 说明：如果后续需要导入完整数据（例如全部 36x22 颗卫星或 15 颗示例卫星），可以：
> - 继续编写 `003_seed_full_data.sql`，或
> - 在 Go 后端中实现数据导入脚本（类似旧项目的 `inser_data.py`），从 JSON/CSV 自动导入。

## 使用方式

### 1. 确保 PostgreSQL 已部署

在 Kubernetes 中：

```bash
kubectl apply -f k8s/database/postgres-secret.yaml
kubectl apply -f k8s/database/postgres-service.yaml
kubectl apply -f k8s/database/postgres-statefulset.yaml
```

确认数据库 Pod 正常运行：

```bash
kubectl get pods -n satellite-system -l app=satellite-postgres
```

### 2. 在数据库中执行迁移脚本

本地或 CI 中使用 `psql` 执行：

```bash
cd backend

# 1) 初始化表结构
psql \"host=<db-host> port=5432 dbname=satellite_db user=satellite_user password=satellite_pass\" \\
  -f migrations/001_init_schema.sql

# 2) 导入最小示例数据
psql \"host=<db-host> port=5432 dbname=satellite_db user=satellite_user password=satellite_pass\" \\
  -f migrations/002_seed_data.sql
```

在 Kubernetes 中，可以通过临时 Pod 执行，例如：

```bash
kubectl run db-migrator --rm -it \\
  --image=docker.m.daocloud.io/library/postgres:15-alpine \\
  --namespace satellite-system --restart=Never -- \\
  sh -c \"psql \\
    -h satellite-postgres \\
    -U satellite_user \\
    -d satellite_db \\
    -f /migrations/001_init_schema.sql\"
```

> 注意：上面的命令需要你把 `migrations/*.sql` 挂载到 Pod 中（ConfigMap 或镜像内置），这里给的是一个参考执行方式。

### 3. 与 Go 后端联动

后端通过环境变量连接数据库（已在 `k8s/backend/deployment.yaml` 中配置）：

- `SATELLITE_DATABASE_HOST` = `satellite-postgres`
- `SATELLITE_DATABASE_PORT` = `5432`
- `SATELLITE_DATABASE_USER` = `satellite_user`
- `SATELLITE_DATABASE_PASSWORD` = `satellite_pass`
- `SATELLITE_DATABASE_DBNAME` = `satellite_db`

在迁移脚本执行完成后，Go 后端即可直接使用这些表结构和初始数据提供 API：

- `GET /api/scenarios/`
- `GET /api/scenarios/{id}`
- `GET /api/scenarios/{id}/satellites`
- `GET /api/satellites/`
- `GET /api/satellites/{id}`

## 后续扩展建议

1. **完整数据导入**
   - 从现有 JSON（如 `starlink_shell1_36x22.json`）或 CSV 数据生成完整的 `INSERT` 脚本
   - 或在 Go 中实现数据导入工具（读取 JSON/CSV → 写入 PostgreSQL）

2. **版本化迁移**
   - 可以引入 goose / sql-migrate / migrate 等 Go 社区迁移工具
   - 将 `001_init_schema.sql` / `002_seed_data.sql` 纳入统一管理

3. **CI 集成**
   - 在 GitLab CI 中增加一个 `db-migrate` job：
     - 在部署后端前执行 001/002 脚本
     - 确保环境一致性

