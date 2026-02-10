-- 添加软删除字段到 scenarios 和 satellites 表
-- 适用于 PostgreSQL

-- 为 scenarios 表增加 deleted_at 字段（如果不存在）
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'scenarios'
          AND column_name = 'deleted_at'
    ) THEN
        ALTER TABLE scenarios
            ADD COLUMN deleted_at TIMESTAMPTZ;
    END IF;
END;
$$;

-- 为 scenarios.deleted_at 创建索引（如果不存在）
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'idx_scenarios_deleted_at'
          AND n.nspname = 'public'
    ) THEN
        CREATE INDEX idx_scenarios_deleted_at
            ON scenarios (deleted_at);
    END IF;
END;
$$;

-- 为 satellites 表增加 deleted_at 字段（如果不存在）
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'satellites'
          AND column_name = 'deleted_at'
    ) THEN
        ALTER TABLE satellites
            ADD COLUMN deleted_at TIMESTAMPTZ;
    END IF;
END;
$$;

-- 为 satellites.deleted_at 创建索引（如果不存在）
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'idx_satellites_deleted_at'
          AND n.nspname = 'public'
    ) THEN
        CREATE INDEX idx_satellites_deleted_at
            ON satellites (deleted_at);
    END IF;
END;
$$;