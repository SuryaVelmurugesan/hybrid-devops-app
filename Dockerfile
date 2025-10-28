# Dockerfile (place at repo root)
FROM node:18-alpine

WORKDIR /app

# copy only package manifests from the app folder
COPY app/package*.json ./


RUN if [ -f package-lock.json ]; then \
      npm ci --omit=dev; \
    else \
      npm install --omit=dev; \
    fi

# copy app source
COPY app/ .

EXPOSE 3000


CMD ["node", "server.js"]
