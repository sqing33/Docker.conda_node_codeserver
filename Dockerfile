# Dockerfile
FROM continuumio/miniconda3

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# 设置 Conda 环境和 pip 镜像源，将 conda 环境和依赖安装位置设置为 /app/conda_envs
RUN mkdir -p /app/conda_envs && \
    echo 'envs_dirs:' >> /root/.condarc && \
    echo '  - /app/conda_envs' >> /root/.condarc && \
    echo 'pkgs_dirs:' >> /root/.condarc && \
    echo '  - /app/conda_envs/pkgs' >> /root/.condarc && \
    pip config set global.index-url https://mirrors.huaweicloud.com/repository/pypi/simple && \
    pip config set install.trusted-host mirrors.huaweicloud.com

# 安装 pnpm ，设置镜像源，将 pnpm 缓存位置设置为/app/pnpm_store
RUN npm install -g pnpm && \
    apt-get purge -y npm && \
    mkdir -p /app/Code/pnpm_store && \
    pnpm config set store-dir /app/Code/pnpm_store && \
    npm config set registry https://mirrors.huaweicloud.com/repository/npm/ && \
    pnpm config set registry https://mirrors.huaweicloud.com/repository/npm/

# 安装 code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# 定义容器启动时执行的命令
CMD ["bash", "-c", "code-server --bind-addr 0.0.0.0:18888 --auth none /app"]
