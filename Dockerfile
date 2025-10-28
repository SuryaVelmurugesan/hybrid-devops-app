# build stage
FROM node:20-slim AS builder
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci --only=production --no-audit --no-fund
COPY . .

# final minimal image
FROM node:20-slim
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 3000
CMD ["node","server.js"]
