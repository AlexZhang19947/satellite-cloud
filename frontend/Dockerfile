FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci || npm install

COPY . .

# 构建静态文件
RUN npm run build

# 运行阶段：使用 Nginx 提供静态文件
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY --from=builder /app/dist/ .

# 可选：自定义 Nginx 配置（例如单页应用路由）
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

