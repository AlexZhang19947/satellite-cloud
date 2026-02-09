# 项目需求确认清单

在开始实施前，请确认以下信息，这将帮助我们更好地定制化项目配置。

## 1. 集群信息

- [✅] **Kubernetes 版本**：`kubectl version --short` 输出
      Client Version: v1.28.15
      Kustomzie Version: v5.0.4-0.20230601165947-6ce0bf390ce3
      Server Version:  v1.28.15
- [✅] **Ingress Controller 类型**：
  - [ ] Nginx Ingress
  - [ ] Traefik
  - [✅] 其他：新建集群，当前仅进行了istio/harbor/granfana/promethues等配置，未进行实际服务部署。
- [✅] **存储类（StorageClass）**：`kubectl get storageclass` 输出
      local-storage（default） kubernetes.io/no-provisioner Delete WaitForFirstConsumer false 40d
- [ ] **镜像仓库**：
  - [ ] GitLab Container Registry
  - [✅] Harbor
  - [ ] Docker Hub
  - [ ] 其他：___________
- [ ] **镜像仓库地址**：主机名称：k8s-repository，地址为192.168.19.238/library/

## 2. 网络配置

- [✅] **域名配置**：
  - 开发环境：未配置
  - 生产环境：未配置
- [ ] **TLS 证书管理方式**：
  - [ ] Let's Encrypt (cert-manager)
  - [ ] 自有证书
  - [✅] 其他：pcl@k8s-repository:/etc/harbor/ssl/harbor.crt
- [ ] **是否需要内网访问**：
  - [✅] 是
  - [ ] 否
- [✅] **内网访问地址**：master：192.168.10.113，k8s-repository：192.168.10.238，其他地址详见“集群部署情况”。

## 3. 数据迁移

- [✅] **现有数据量**：
  - 场景数量：2
  - 卫星数量：15
  - 数据库大小：k8s当前无部署，该代码与Django旧版本及前端、数据库代码功能保持一致即可。
- [ ] **是否需要数据迁移脚本**：
  - [ ] 是（需要从 Django 数据库迁移）
  - [✅] 否（新建数据库），注：数据内容与现有代码保持一致即可
- [ ] **是否需要双写（新旧系统同时写入）**：
  - [ ] 是
  - [✅] 否

## 4. 性能要求

- [✅] **预期 QPS（每秒查询数）**：无特别要求
- [✅] **并发用户数**：无特别要求
- [✅] **响应时间要求**：
  - API 响应时间：无特别要求
  - 页面加载时间：无特别要求

## 5. 监控和日志

- [✅] **是否已有 Prometheus**：
  - [✅] 是
  - [ ] 否
- [✅] **是否已有 Grafana**：
  - [✅] 是
  - [ ] 否
- [✅] **日志收集方案**：
  - [ ] ELK Stack
  - [✅] Loki + Grafana
  - [ ] 其他：___________
- [✅] **告警通知方式**：
  - [ ] 邮件
  - [ ] 钉钉/企业微信
  - [ ] Slack
  - [✅] 其他：无要求

## 6. CI/CD 配置

- [✅] **GitLab 版本**：v16.8.1
- [✅] **是否需要多环境**：
  - [✅] 开发环境（dev）
  - [ ] 测试环境（staging）
  - [ ] 生产环境（prod）
- [✅] **部署策略**：
  - [ ] 蓝绿部署
  - [✅] 滚动更新（Rolling Update）
  - [ ] 金丝雀发布（Canary）
- [ ] **Kubernetes 上下文名称**：
  - 开发环境：如下
  - 生产环境：如下
  应该没有配置，使用如下指令返回：
  kubectl config get-contexts
  CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
  *         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin 

## 7. 数据库配置

- [✅] **PostgreSQL 版本**：未安装
- [✅] **是否需要高可用（HA）**：
  - [✅] 是（主从复制）
  - [ ] 否（单实例）
- [✅] **数据备份策略**：
  - [✅] 需要自动备份
  - [ ] 手动备份即可
- [✅] **备份保留时间**：1 week

## 8. 安全要求

- [✅] **是否需要认证/授权**：
  - [ ] 是（JWT/OAuth2）
  - [✅] 否（公开访问）
- [✅] **是否需要 API 限流**：
  - [✅] 是
  - [ ] 否
- [✅] **是否需要 WAF（Web 应用防火墙）**：
  - [ ] 是
  - [✅] 否

## 9. 其他需求

- [✅] **特殊要求或约束**：集群包含15个节点，核心插件部署在集群内，gitlab ce、Harbor部署在集群外，ip为192.168.10.238，集群内15个节点ip分别为192.168.10.101-105,111-115,121-125，其中，master节点ip：192.168.10.113。该网段为管理网段，集群内业务网段如下述‘集群部署情况’所示。
- [✅] **项目时间表**：2026年完成
- [✅] **团队规模**：3人
- [✅] **前端代码**：与旧版保持一致，具体与k8s集群适配开发请你帮忙调整。
- [✅] **集群部署情况**：
pcl@k8s-master:/opt/gitlab-runner$ kubectl get all -A -owide
NAMESPACE        NAME                                                            READY   STATUS    RESTARTS       AGE     IP             NODE           NOMINATED NODE   READINESS GATES
gitlab-runner    pod/gitlab-runner-7f6c79c765-j9lcb                              1/1     Running   0              3d16h   10.244.6.35    k8s-worker21   <none>           <none>
gitlab-runner    pod/gitlab-runner-7f6c79c765-lb7l6                              1/1     Running   0              3d16h   10.244.14.32   k8s-worker35   <none>           <none>
gitlab-runner    pod/gitlab-runner-7f6c79c765-njcrb                              1/1     Running   0              3d16h   10.244.7.20    k8s-worker22   <none>           <none>
gitlab-runner    pod/test-app-57b76dd94c-mxfgs                                   1/1     Running   0              2d17h   10.244.13.15   k8s-worker34   <none>           <none>
istio-system     pod/grafana-7754cb9855-vqxnq                                    1/1     Running   78 (19d ago)   48d     10.244.13.12   k8s-worker34   <none>           <none>
istio-system     pod/istio-egressgateway-55dd89bc54-wqwtj                        1/1     Running   1 (34d ago)    51d     10.244.14.14   k8s-worker35   <none>           <none>
istio-system     pod/istio-ingressgateway-6d95b4778-46bxt                        1/1     Running   1 (34d ago)    51d     10.244.1.14    k8s-worker11   <none>           <none>
istio-system     pod/istiod-6bf6fbf46b-4c749                                     1/1     Running   1 (34d ago)    51d     10.244.5.9     k8s-worker15   <none>           <none>
istio-system     pod/jaeger-84768f46f9-nxq7p                                     1/1     Running   1 (34d ago)    48d     10.244.7.10    k8s-worker22   <none>           <none>
istio-system     pod/kiali-765bb494ff-db22x                                      1/1     Running   1 (34d ago)    48d     10.244.9.13    k8s-worker25   <none>           <none>
istio-system     pod/prometheus-db8b4588f-ml9kt                                  2/2     Running   2 (34d ago)    48d     10.244.12.13   k8s-worker33   <none>           <none>
kube-flannel     pod/kube-flannel-ds-26wbm                                       1/1     Running   3 (34d ago)    52d     10.2.1.10      k8s-worker21   <none>           <none>
kube-flannel     pod/kube-flannel-ds-4kpr9                                       1/1     Running   1 (34d ago)    52d     10.3.5.10      k8s-worker35   <none>           <none>
kube-flannel     pod/kube-flannel-ds-5sfhp                                       1/1     Running   5 (24d ago)    52d     10.2.3.10      k8s-master     <none>           <none>
kube-flannel     pod/kube-flannel-ds-7vkfd                                       1/1     Running   1 (34d ago)    52d     10.2.2.10      k8s-worker22   <none>           <none>
kube-flannel     pod/kube-flannel-ds-959p4                                       1/1     Running   1 (34d ago)    52d     10.2.4.10      k8s-worker24   <none>           <none>
kube-flannel     pod/kube-flannel-ds-c288j                                       1/1     Running   1 (34d ago)    52d     10.1.3.10      k8s-worker13   <none>           <none>
kube-flannel     pod/kube-flannel-ds-chmpp                                       1/1     Running   1 (34d ago)    52d     10.1.1.10      k8s-worker11   <none>           <none>
kube-flannel     pod/kube-flannel-ds-csgsz                                       1/1     Running   1 (34d ago)    52d     10.3.3.10      k8s-worker33   <none>           <none>
kube-flannel     pod/kube-flannel-ds-cvk27                                       1/1     Running   1 (34d ago)    52d     10.3.4.10      k8s-worker34   <none>           <none>
kube-flannel     pod/kube-flannel-ds-dxb2h                                       1/1     Running   1 (34d ago)    52d     10.3.2.10      k8s-worker32   <none>           <none>
kube-flannel     pod/kube-flannel-ds-pdrs9                                       1/1     Running   1 (34d ago)    52d     10.2.5.10      k8s-worker25   <none>           <none>
kube-flannel     pod/kube-flannel-ds-tkf4h                                       1/1     Running   1 (34d ago)    52d     10.1.5.10      k8s-worker15   <none>           <none>
kube-flannel     pod/kube-flannel-ds-vk9vw                                       1/1     Running   1 (34d ago)    52d     10.1.2.10      k8s-worker12   <none>           <none>
kube-flannel     pod/kube-flannel-ds-w26zt                                       1/1     Running   1 (34d ago)    52d     10.1.4.10      k8s-worker14   <none>           <none>
kube-flannel     pod/kube-flannel-ds-zvxgj                                       1/1     Running   1 (34d ago)    52d     10.3.1.10      k8s-worker31   <none>           <none>
kube-system      pod/coredns-66f779496c-lt6nw                                    1/1     Running   1 (34d ago)    52d     10.244.4.11    k8s-worker14   <none>           <none>
kube-system      pod/coredns-66f779496c-mkghb                                    1/1     Running   1 (34d ago)    52d     10.244.8.12    k8s-worker24   <none>           <none>
kube-system      pod/etcd-k8s-master                                             1/1     Running   4 (24d ago)    65d     10.2.3.10      k8s-master     <none>           <none>
kube-system      pod/kube-apiserver-k8s-master                                   1/1     Running   5 (24d ago)    65d     10.2.3.10      k8s-master     <none>           <none>
kube-system      pod/kube-controller-manager-k8s-master                          1/1     Running   14 (24d ago)   65d     10.2.3.10      k8s-master     <none>           <none>
kube-system      pod/kube-proxy-6z56c                                            1/1     Running   2 (34d ago)    65d     10.1.1.10      k8s-worker11   <none>           <none>
kube-system      pod/kube-proxy-9zzm2                                            1/1     Running   2 (34d ago)    65d     10.3.5.10      k8s-worker35   <none>           <none>
kube-system      pod/kube-proxy-dwrlz                                            1/1     Running   2 (34d ago)    65d     10.2.4.10      k8s-worker24   <none>           <none>
kube-system      pod/kube-proxy-hgwc2                                            1/1     Running   2 (34d ago)    65d     10.1.2.10      k8s-worker12   <none>           <none>
kube-system      pod/kube-proxy-hp964                                            1/1     Running   2 (34d ago)    65d     10.3.4.10      k8s-worker34   <none>           <none>
kube-system      pod/kube-proxy-jch4s                                            1/1     Running   2 (34d ago)    65d     10.2.5.10      k8s-worker25   <none>           <none>
kube-system      pod/kube-proxy-jx97m                                            1/1     Running   4 (34d ago)    65d     10.2.1.10      k8s-worker21   <none>           <none>
kube-system      pod/kube-proxy-nfbdv                                            1/1     Running   2 (34d ago)    65d     10.3.1.10      k8s-worker31   <none>           <none>
kube-system      pod/kube-proxy-p6jd4                                            1/1     Running   4 (24d ago)    65d     10.2.3.10      k8s-master     <none>           <none>
kube-system      pod/kube-proxy-qls7l                                            1/1     Running   2 (34d ago)    65d     10.3.2.10      k8s-worker32   <none>           <none>
kube-system      pod/kube-proxy-s454v                                            1/1     Running   2 (34d ago)    65d     10.1.3.10      k8s-worker13   <none>           <none>
kube-system      pod/kube-proxy-sjldk                                            1/1     Running   2              65d     10.1.4.10      k8s-worker14   <none>           <none>
kube-system      pod/kube-proxy-tddcj                                            1/1     Running   2 (34d ago)    65d     10.1.5.10      k8s-worker15   <none>           <none>
kube-system      pod/kube-proxy-wfzc4                                            1/1     Running   2 (34d ago)    65d     10.2.2.10      k8s-worker22   <none>           <none>
kube-system      pod/kube-proxy-x2g2k                                            1/1     Running   2 (34d ago)    65d     10.3.3.10      k8s-worker33   <none>           <none>
kube-system      pod/kube-scheduler-k8s-master                                   1/1     Running   14 (24d ago)   65d     10.2.3.10      k8s-master     <none>           <none>
kube-system      pod/metrics-server-5449dbb568-xbwhx                             1/1     Running   1 (34d ago)    48d     10.244.11.13   k8s-worker32   <none>           <none>
monitoring       pod/alertmanager-kube-prometheus-stack-alertmanager-0           2/2     Running   2 (34d ago)    41d     10.244.4.12    k8s-worker14   <none>           <none>
monitoring       pod/kube-prometheus-stack-grafana-78b778d96b-krhhw              3/3     Running   0              31d     10.244.3.18    k8s-worker13   <none>           <none>
monitoring       pod/kube-prometheus-stack-kube-state-metrics-6966f649f9-w64l2   1/1     Running   3 (24d ago)    41d     10.244.9.16    k8s-worker25   <none>           <none>
monitoring       pod/kube-prometheus-stack-operator-54c6b9f9cf-2qfsg             1/1     Running   1 (34d ago)    41d     10.244.2.15    k8s-worker12   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-7shl9        1/1     Running   1 (34d ago)    41d     10.1.2.10      k8s-worker12   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-95jcl        1/1     Running   1 (39d ago)    41d     10.3.3.10      k8s-worker33   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-9jd7b        1/1     Running   1 (34d ago)    41d     10.3.5.10      k8s-worker35   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-c8qp4        1/1     Running   2 (24d ago)    41d     10.2.3.10      k8s-master     <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-d2hwv        1/1     Running   1 (34d ago)    41d     10.2.1.10      k8s-worker21   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-fphts        1/1     Running   1 (34d ago)    41d     10.1.1.10      k8s-worker11   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-g4jfn        1/1     Running   1 (34d ago)    41d     10.2.2.10      k8s-worker22   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-ld8l7        1/1     Running   1 (34d ago)    41d     10.3.2.10      k8s-worker32   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-mbsdt        1/1     Running   1 (34d ago)    41d     10.1.3.10      k8s-worker13   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-mgcfj        1/1     Running   1 (34d ago)    41d     10.3.1.10      k8s-worker31   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-nqmb6        1/1     Running   1 (34d ago)    41d     10.2.4.10      k8s-worker24   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-p8bfs        1/1     Running   1 (34d ago)    41d     10.1.5.10      k8s-worker15   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-pbhfz        1/1     Running   1 (34d ago)    41d     10.1.4.10      k8s-worker14   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-px4fr        1/1     Running   1 (34d ago)    41d     10.3.4.10      k8s-worker34   <none>           <none>
monitoring       pod/kube-prometheus-stack-prometheus-node-exporter-ww2hv        1/1     Running   1 (34d ago)    41d     10.2.5.10      k8s-worker25   <none>           <none>
monitoring       pod/loki-stack-0                                                1/1     Running   1 (34d ago)    41d     10.244.10.16   k8s-worker31   <none>           <none>
monitoring       pod/loki-stack-promtail-5hd92                                   1/1     Running   1 (39d ago)    41d     10.244.12.12   k8s-worker33   <none>           <none>
monitoring       pod/loki-stack-promtail-72w8j                                   1/1     Running   1 (34d ago)    41d     10.244.4.13    k8s-worker14   <none>           <none>
monitoring       pod/loki-stack-promtail-76ccf                                   1/1     Running   1 (34d ago)    41d     10.244.8.13    k8s-worker24   <none>           <none>
monitoring       pod/loki-stack-promtail-8mln8                                   1/1     Running   1 (34d ago)    41d     10.244.3.16    k8s-worker13   <none>           <none>
monitoring       pod/loki-stack-promtail-9m4nc                                   1/1     Running   1 (34d ago)    41d     10.244.10.17   k8s-worker31   <none>           <none>
monitoring       pod/loki-stack-promtail-dbhsp                                   1/1     Running   1 (34d ago)    41d     10.244.2.14    k8s-worker12   <none>           <none>
monitoring       pod/loki-stack-promtail-fd9wb                                   1/1     Running   1 (34d ago)    41d     10.244.5.10    k8s-worker15   <none>           <none>
monitoring       pod/loki-stack-promtail-js56p                                   1/1     Running   1 (34d ago)    41d     10.244.7.11    k8s-worker22   <none>           <none>
monitoring       pod/loki-stack-promtail-jxx9m                                   1/1     Running   1 (34d ago)    41d     10.244.6.14    k8s-worker21   <none>           <none>
monitoring       pod/loki-stack-promtail-kkz4r                                   1/1     Running   1 (34d ago)    41d     10.244.9.15    k8s-worker25   <none>           <none>
monitoring       pod/loki-stack-promtail-lzq89                                   1/1     Running   1 (34d ago)    41d     10.244.13.13   k8s-worker34   <none>           <none>
monitoring       pod/loki-stack-promtail-qjwf6                                   1/1     Running   1 (34d ago)    41d     10.244.14.12   k8s-worker35   <none>           <none>
monitoring       pod/loki-stack-promtail-r6847                                   1/1     Running   1 (34d ago)    41d     10.244.11.14   k8s-worker32   <none>           <none>
monitoring       pod/loki-stack-promtail-wmbw6                                   1/1     Running   2 (24d ago)    41d     10.244.0.20    k8s-master     <none>           <none>
monitoring       pod/loki-stack-promtail-xtwk6                                   1/1     Running   1 (34d ago)    41d     10.244.1.13    k8s-worker11   <none>           <none>
monitoring       pod/prometheus-adapter-5485d85659-ndvx5                         1/1     Running   1 (34d ago)    41d     10.244.10.14   k8s-worker31   <none>           <none>
monitoring       pod/prometheus-kube-prometheus-stack-prometheus-0               2/2     Running   2 (34d ago)    41d     10.244.8.10    k8s-worker24   <none>           <none>
satellite-test   pod/net-test-4tv7j                                              2/2     Running   2 (34d ago)    46d     10.244.12.11   k8s-worker33   <none>           <none>
satellite-test   pod/net-test-5m96l                                              2/2     Running   2 (34d ago)    46d     10.244.4.10    k8s-worker14   <none>           <none>
satellite-test   pod/net-test-6bw7v                                              2/2     Running   2 (34d ago)    46d     10.244.7.12    k8s-worker22   <none>           <none>
satellite-test   pod/net-test-gwvbr                                              2/2     Running   2 (34d ago)    46d     10.244.1.12    k8s-worker11   <none>           <none>
satellite-test   pod/net-test-hgklz                                              2/2     Running   2 (34d ago)    46d     10.244.11.12   k8s-worker32   <none>           <none>
satellite-test   pod/net-test-hnbvl                                              2/2     Running   2 (34d ago)    46d     10.244.8.11    k8s-worker24   <none>           <none>
satellite-test   pod/net-test-jxrhr                                              2/2     Running   2 (34d ago)    46d     10.244.9.14    k8s-worker25   <none>           <none>
satellite-test   pod/net-test-mjkfq                                              2/2     Running   4 (24d ago)    46d     10.244.0.21    k8s-master     <none>           <none>
satellite-test   pod/net-test-qfrl9                                              2/2     Running   2 (34d ago)    46d     10.244.5.11    k8s-worker15   <none>           <none>
satellite-test   pod/net-test-qnt29                                              2/2     Running   2 (34d ago)    46d     10.244.6.12    k8s-worker21   <none>           <none>
satellite-test   pod/net-test-rfnkh                                              2/2     Running   2 (34d ago)    46d     10.244.14.13   k8s-worker35   <none>           <none>
satellite-test   pod/net-test-sj7b7                                              2/2     Running   2 (34d ago)    46d     10.244.10.15   k8s-worker31   <none>           <none>
satellite-test   pod/net-test-twdlp                                              2/2     Running   2 (34d ago)    46d     10.244.13.11   k8s-worker34   <none>           <none>
satellite-test   pod/net-test-xffv5                                              2/2     Running   2 (34d ago)    46d     10.244.3.15    k8s-worker13   <none>           <none>
satellite-test   pod/net-test-xxw2n                                              2/2     Running   2 (34d ago)    46d     10.244.2.13    k8s-worker12   <none>           <none>

NAMESPACE       NAME                                                     TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                      AGE     SELECTOR
default         service/kubernetes                                       ClusterIP   10.96.0.1        <none>        443/TCP                                                      65d     <none>
gitlab-runner   service/test-app                                         ClusterIP   10.108.241.188   <none>        80/TCP                                                       2d19h   app=test-app
istio-system    service/grafana                                          NodePort    10.106.37.76     <none>        3000:30300/TCP                                               48d     app.kubernetes.io/instance=grafana,app.kubernetes.io/name=grafana
istio-system    service/istio-egressgateway                              ClusterIP   10.99.133.197    <none>        80/TCP,443/TCP                                               51d     app=istio-egressgateway,istio=egressgateway
istio-system    service/istio-ingressgateway                             NodePort    10.110.223.243   <none>        15021:30973/TCP,80:30080/TCP,443:30443/TCP,15443:30998/TCP   51d     app=istio-ingressgateway,istio=ingressgateway
istio-system    service/istiod                                           ClusterIP   10.105.90.193    <none>        15010/TCP,15012/TCP,443/TCP,15014/TCP                        51d     app=istiod,istio=pilot
istio-system    service/jaeger-collector                                 ClusterIP   10.100.176.5     <none>        14268/TCP,14250/TCP,9411/TCP,4317/TCP,4318/TCP               48d     app=jaeger
istio-system    service/kiali                                            NodePort    10.104.41.40     <none>        20001:30200/TCP,9090:32534/TCP                               48d     app.kubernetes.io/instance=kiali,app.kubernetes.io/name=kiali
istio-system    service/prometheus                                       ClusterIP   10.107.171.228   <none>        9090/TCP                                                     48d     app=prometheus,component=server,release=prometheus
istio-system    service/tracing                                          NodePort    10.100.154.205   <none>        80:30686/TCP,16685:32647/TCP                                 48d     app=jaeger
istio-system    service/zipkin                                           ClusterIP   10.106.14.69     <none>        9411/TCP                                                     48d     app=jaeger
kube-system     service/kube-dns                                         ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP                                       65d     k8s-app=kube-dns
kube-system     service/kube-prometheus-stack-coredns                    ClusterIP   None             <none>        9153/TCP                                                     41d     k8s-app=kube-dns
kube-system     service/kube-prometheus-stack-kube-controller-manager    ClusterIP   None             <none>        10257/TCP                                                    41d     component=kube-controller-manager
kube-system     service/kube-prometheus-stack-kube-etcd                  ClusterIP   None             <none>        2381/TCP                                                     41d     component=etcd
kube-system     service/kube-prometheus-stack-kube-proxy                 ClusterIP   None             <none>        10249/TCP                                                    41d     k8s-app=kube-proxy
kube-system     service/kube-prometheus-stack-kube-scheduler             ClusterIP   None             <none>        10259/TCP                                                    41d     component=kube-scheduler
kube-system     service/kube-prometheus-stack-kubelet                    ClusterIP   None             <none>        10250/TCP,10255/TCP,4194/TCP                                 41d     <none>
kube-system     service/metrics-server                                   ClusterIP   10.111.140.58    <none>        443/TCP                                                      48d     k8s-app=metrics-server
monitoring      service/alertmanager-operated                            ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP                                   41d     app.kubernetes.io/name=alertmanager
monitoring      service/kube-prometheus-stack-alertmanager               NodePort    10.107.17.35     <none>        9093:30093/TCP,8080:31114/TCP                                41d     alertmanager=kube-prometheus-stack-alertmanager,app.kubernetes.io/name=alertmanager
monitoring      service/kube-prometheus-stack-grafana                    NodePort    10.97.247.127    <none>        80:30001/TCP                                                 41d     app.kubernetes.io/instance=kube-prometheus-stack,app.kubernetes.io/name=grafana
monitoring      service/kube-prometheus-stack-kube-state-metrics         ClusterIP   10.106.61.61     <none>        8080/TCP                                                     41d     app.kubernetes.io/instance=kube-prometheus-stack,app.kubernetes.io/name=kube-state-metrics
monitoring      service/kube-prometheus-stack-operator                   ClusterIP   10.106.172.115   <none>        443/TCP                                                      41d     app=kube-prometheus-stack-operator,release=kube-prometheus-stack
monitoring      service/kube-prometheus-stack-prometheus                 NodePort    10.110.227.33    <none>        9090:30090/TCP,8080:31867/TCP                                41d     app.kubernetes.io/name=prometheus,operator.prometheus.io/name=kube-prometheus-stack-prometheus
monitoring      service/kube-prometheus-stack-prometheus-node-exporter   ClusterIP   10.105.170.197   <none>        9100/TCP                                                     41d     app.kubernetes.io/instance=kube-prometheus-stack,app.kubernetes.io/name=prometheus-node-exporter
monitoring      service/loki-stack                                       ClusterIP   10.110.54.81     <none>        3100/TCP                                                     41d     app=loki,release=loki-stack
monitoring      service/loki-stack-headless                              ClusterIP   None             <none>        3100/TCP                                                     41d     app=loki,release=loki-stack
monitoring      service/loki-stack-memberlist                            ClusterIP   None             <none>        7946/TCP                                                     41d     app=loki,release=loki-stack
monitoring      service/prometheus-adapter                               ClusterIP   10.107.164.178   <none>        443/TCP                                                      41d     app.kubernetes.io/instance=prometheus-adapter,app.kubernetes.io/name=prometheus-adapter
monitoring      service/prometheus-operated                              ClusterIP   None             <none>        9090/TCP                                                     41d     app.kubernetes.io/name=prometheus

NAMESPACE        NAME                                                            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE   CONTAINERS      IMAGES                                                        SELECTOR
kube-flannel     daemonset.apps/kube-flannel-ds                                  15        15        15      15           15          <none>                   65d   kube-flannel    ghcr.io/flannel-io/flannel:v0.27.4                            app=flannel
kube-system      daemonset.apps/kube-proxy                                       15        15        15      15           15          kubernetes.io/os=linux   65d   kube-proxy      registry.aliyuncs.com/google_containers/kube-proxy:v1.28.15   k8s-app=kube-proxy
monitoring       daemonset.apps/kube-prometheus-stack-prometheus-node-exporter   15        15        15      15           15          kubernetes.io/os=linux   41d   node-exporter   quay.io/prometheus/node-exporter:v1.10.2                      app.kubernetes.io/instance=kube-prometheus-stack,app.kubernetes.io/name=prometheus-node-exporter
monitoring       daemonset.apps/loki-stack-promtail                              15        15        15      15           15          <none>                   41d   promtail        docker.io/grafana/promtail:3.5.1                              app.kubernetes.io/instance=loki-stack,app.kubernetes.io/name=promtail
satellite-test   daemonset.apps/net-test                                         15        15        15      15           15          <none>                   46d   net-test        192.168.10.238/library/busybox:latest                         name=net-test

NAMESPACE       NAME                                                       READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS                                             IMAGES                                                                                                   SELECTOR
gitlab-runner   deployment.apps/gitlab-runner                              3/3     3            3           3d16h   gitlab-runner                                          gitlab/gitlab-runner:alpine-v16.8.0                                                                      app=gitlab-runner
gitlab-runner   deployment.apps/test-app                                   1/1     1            1           2d19h   test-app                                               192.168.10.238/library/test-app:ff166555                                                                 app=test-app
istio-system    deployment.apps/grafana                                    1/1     1            1           48d     grafana                                                m.daocloud.io/docker.io/grafana/grafana:9.5.5                                                            app.kubernetes.io/instance=grafana,app.kubernetes.io/name=grafana
istio-system    deployment.apps/istio-egressgateway                        1/1     1            1           51d     istio-proxy                                            docker.m.daocloud.io/istio/proxyv2:1.20.2                                                                app=istio-egressgateway,istio=egressgateway
istio-system    deployment.apps/istio-ingressgateway                       1/1     1            1           51d     istio-proxy                                            docker.m.daocloud.io/istio/proxyv2:1.20.2                                                                app=istio-ingressgateway,istio=ingressgateway
istio-system    deployment.apps/istiod                                     1/1     1            1           51d     discovery                                              docker.m.daocloud.io/istio/pilot:1.20.2                                                                  istio=pilot
istio-system    deployment.apps/jaeger                                     1/1     1            1           48d     jaeger                                                 m.daocloud.io/docker.io/jaegertracing/all-in-one:1.46                                                    app=jaeger
istio-system    deployment.apps/kiali                                      1/1     1            1           48d     kiali                                                  m.daocloud.io/quay.io/kiali/kiali:v1.76                                                                  app.kubernetes.io/instance=kiali,app.kubernetes.io/name=kiali
istio-system    deployment.apps/prometheus                                 1/1     1            1           48d     prometheus-server-configmap-reload,prometheus-server   jimmidyson/configmap-reload:v0.8.0,prom/prometheus:v2.41.0                                               app=prometheus,component=server,release=prometheus
kube-system     deployment.apps/coredns                                    2/2     2            2           65d     coredns                                                registry.aliyuncs.com/google_containers/coredns:v1.10.1                                                  k8s-app=kube-dns
kube-system     deployment.apps/metrics-server                             1/1     1            1           48d     metrics-server                                         m.daocloud.io/registry.k8s.io/metrics-server/metrics-server:v0.8.0                                       k8s-app=metrics-server
monitoring      deployment.apps/kube-prometheus-stack-grafana              1/1     1            1           41d     grafana-sc-dashboard,grafana-sc-datasources,grafana    quay.io/kiwigrid/k8s-sidecar:2.1.2,quay.io/kiwigrid/k8s-sidecar:2.1.2,docker.io/grafana/grafana:12.3.0   app.kubernetes.io/instance=kube-prometheus-stack,app.kubernetes.io/name=grafana
monitoring      deployment.apps/kube-prometheus-stack-kube-state-metrics   1/1     1            1           41d     kube-state-metrics                                     registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.17.0                                            app.kubernetes.io/instance=kube-prometheus-stack,app.kubernetes.io/name=kube-state-metrics
monitoring      deployment.apps/kube-prometheus-stack-operator             1/1     1            1           41d     kube-prometheus-stack                                  quay.io/prometheus-operator/prometheus-operator:v0.87.1                                                  app=kube-prometheus-stack-operator,release=kube-prometheus-stack
monitoring      deployment.apps/prometheus-adapter                         1/1     1            1           41d     prometheus-adapter                                     registry.k8s.io/prometheus-adapter/prometheus-adapter:v0.12.0                                            app.kubernetes.io/instance=prometheus-adapter,app.kubernetes.io/name=prometheus-adapter

NAMESPACE       NAME                                                                  DESIRED   CURRENT   READY   AGE     CONTAINERS                                             IMAGES                                                                                                   SELECTORgitlab-runner   replicaset.apps/gitlab-runner-7f6c79c765                              3         3         3       3d16h   gitlab-runner                                          gitlab/gitlab-runner:alpine-v16.8.0                                                                      app=gitlab-runner,pod-template-hash=7f6c79c765
gitlab-runner   replicaset.apps/test-app-57b76dd94c                                   1         1         1       2d17h   test-app                                               192.168.10.238/library/test-app:ff166555                                                                 app=test-app,pod-template-hash=57b76dd94c
gitlab-runner   replicaset.apps/test-app-586fc8d6cf                                   0         0         0       2d18h   test-app                                               192.168.10.238/library/test-app:600b1519                                                                 app=test-app,pod-template-hash=586fc8d6cf
gitlab-runner   replicaset.apps/test-app-7dd7d6549b                                   0         0         0       2d19h   test-app                                               192.168.10.238/library/test-app:116ae975                                                                 app=test-app,pod-template-hash=7dd7d6549b
gitlab-runner   replicaset.apps/test-app-cc7644cc5                                    0         0         0       2d19h   test-app                                               192.168.10.238/library/test-app:2075b7dc                                                                 app=test-app,pod-template-hash=cc7644cc5
gitlab-runner   replicaset.apps/test-app-fb48878c7                                    0         0         0       2d18h   test-app                                               192.168.10.238/library/test-app:58478165                                                                 app=test-app,pod-template-hash=fb48878c7
istio-system    replicaset.apps/grafana-7754cb9855                                    1         1         1       48d     grafana                                                m.daocloud.io/docker.io/grafana/grafana:9.5.5                                                            app.kubernetes.io/instance=grafana,app.kubernetes.io/name=grafana,pod-template-hash=7754cb9855
istio-system    replicaset.apps/istio-egressgateway-55dd89bc54                        1         1         1       51d     istio-proxy                                            docker.m.daocloud.io/istio/proxyv2:1.20.2                                                                app=istio-egressgateway,istio=egressgateway,pod-template-hash=55dd89bc54
istio-system    replicaset.apps/istio-ingressgateway-6d95b4778                        1         1         1       51d     istio-proxy                                            docker.m.daocloud.io/istio/proxyv2:1.20.2                                                                app=istio-ingressgateway,istio=ingressgateway,pod-template-hash=6d95b4778
istio-system    replicaset.apps/istiod-6bf6fbf46b                                     1         1         1       51d     discovery                                              docker.m.daocloud.io/istio/pilot:1.20.2                                                                  istio=pilot,pod-template-hash=6bf6fbf46b
istio-system    replicaset.apps/jaeger-84768f46f9                                     1         1         1       48d     jaeger                                                 m.daocloud.io/docker.io/jaegertracing/all-in-one:1.46                                                    app=jaeger,pod-template-hash=84768f46f9
istio-system    replicaset.apps/kiali-765bb494ff                                      1         1         1       48d     kiali                                                  m.daocloud.io/quay.io/kiali/kiali:v1.76                                                                  app.kubernetes.io/instance=kiali,app.kubernetes.io/name=kiali,pod-template-hash=765bb494ff
istio-system    replicaset.apps/prometheus-db8b4588f                                  1         1         1       48d     prometheus-server-configmap-reload,prometheus-server   jimmidyson/configmap-reload:v0.8.0,prom/prometheus:v2.41.0                                               app=prometheus,component=server,pod-template-hash=db8b4588f,release=prometheus
kube-system     replicaset.apps/coredns-66f779496c                                    2         2         2       65d     coredns                                                registry.aliyuncs.com/google_containers/coredns:v1.10.1                                                  k8s-app=kube-dns,pod-template-hash=66f779496c
kube-system     replicaset.apps/metrics-server-5449dbb568                             1         1         1       48d     metrics-server                                         m.daocloud.io/registry.k8s.io/metrics-server/metrics-server:v0.8.0                                       k8s-app=metrics-server,pod-template-hash=5449dbb568
monitoring      replicaset.apps/kube-prometheus-stack-grafana-78b778d96b              1         1         1       33d     grafana-sc-dashboard,grafana-sc-datasources,grafana    quay.io/kiwigrid/k8s-sidecar:2.1.2,quay.io/kiwigrid/k8s-sidecar:2.1.2,docker.io/grafana/grafana:12.3.0   app.kubernetes.io/instance=kube-prometheus-stack,app.kubernetes.io/name=grafana,pod-template-hash=78b778d96b
monitoring      replicaset.apps/kube-prometheus-stack-kube-state-metrics-6966f649f9   1         1         1       41d     kube-state-metrics                                     registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.17.0                                            app.kubernetes.io/instance=kube-prometheus-stack,app.kubernetes.io/name=kube-state-metrics,pod-template-hash=6966f649f9
monitoring      replicaset.apps/kube-prometheus-stack-operator-54c6b9f9cf             1         1         1       41d     kube-prometheus-stack                                  quay.io/prometheus-operator/prometheus-operator:v0.87.1                                                  app=kube-prometheus-stack-operator,pod-template-hash=54c6b9f9cf,release=kube-prometheus-stack
monitoring      replicaset.apps/prometheus-adapter-5485d85659                         1         1         1       41d     prometheus-adapter                                     registry.k8s.io/prometheus-adapter/prometheus-adapter:v0.12.0                                            app.kubernetes.io/instance=prometheus-adapter,app.kubernetes.io/name=prometheus-adapter,pod-template-hash=5485d85659

NAMESPACE    NAME                                                               READY   AGE   CONTAINERS                     IMAGES
monitoring   statefulset.apps/alertmanager-kube-prometheus-stack-alertmanager   1/1     41d   alertmanager,config-reloader   quay.io/prometheus/alertmanager:v0.30.0,quay.io/prometheus-operator/prometheus-config-reloader:v0.87.1
monitoring   statefulset.apps/loki-stack                                        1/1     41d   loki                           grafana/loki:2.6.1
monitoring   statefulset.apps/prometheus-kube-prometheus-stack-prometheus       1/1     41d   prometheus,config-reloader     quay.io/prometheus/prometheus:v3.8.1,quay.io/prometheus-operator/prometheus-config-reloader:v0.87.1

NAMESPACE       NAME                                                       REFERENCE                         TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
gitlab-runner   horizontalpodautoscaler.autoscaling/gitlab-runner-hpa      Deployment/gitlab-runner          0%/70%    3         10        3          3d16h
istio-system    horizontalpodautoscaler.autoscaling/istio-egressgateway    Deployment/istio-egressgateway    3%/80%    1         5         1          51d
istio-system    horizontalpodautoscaler.autoscaling/istio-ingressgateway   Deployment/istio-ingressgateway   3%/80%    1         5         1          51d
istio-system    horizontalpodautoscaler.autoscaling/istiod                 Deployment/istiod                 0%/80%    1         3         1          51d

---

**填写说明**：
1. 请在对应选项前打勾 `[x]`
2. 在横线处填写具体信息
3. 如有其他需求，请在"其他需求"部分说明

**联系方式**：
如有疑问，请随时联系开发团队。
