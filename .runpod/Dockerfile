FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive PIP_NO_CACHE_DIR=1 PYTHONUNBUFFERED=1 WORKSPACE=/workspace
RUN apt-get update -y && apt-get install -y --no-install-recommends nginx openssh-server git ca-certificates curl build-essential pkg-config && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt
RUN mkdir -p ${WORKSPACE}/notebooks
COPY notebooks/welcome.py ${WORKSPACE}/notebooks/welcome.py
COPY handler.py /app/handler.py
COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 2718
RUN printf 'user root;\nworker_processes auto;\nerror_log /var/log/nginx/error.log warn;\npid /var/run/nginx.pid;\n' > /etc/nginx/nginx.conf
CMD ["/start.sh"]
