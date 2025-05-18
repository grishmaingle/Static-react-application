# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM nginx:1.25.2-alpine

# Upgrade all packages to latest patched versions to fix vulnerabilities
RUN apk update && apk upgrade && apk --no-cache add curl libexpat libxml2 libxslt

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy build files from builder
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
