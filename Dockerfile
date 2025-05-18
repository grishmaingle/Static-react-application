
# Stage 1: Build the React app using Node.js
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy dependencies files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all project files
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the app using Nginx
FROM nginx:1.25.2-alpine

# Update and install curl for healthcheck
RUN apk update && apk upgrade && \
    apk --no-cache add curl && \
    rm -rf /var/cache/apk/*

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy build artifacts from builder stage to nginx html directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Create nginx configuration for React app
RUN echo 'server {' > /etc/nginx/conf.d/default.conf && \
    echo '    listen 80;' >> /etc/nginx/conf.d/default.conf && \
    echo '    server_name localhost;' >> /etc/nginx/conf.d/default.conf && \
    echo '    root /usr/share/nginx/html;' >> /etc/nginx/conf.d/default.conf && \
    echo '    index index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '    try_files $uri $uri/ /index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '}' >> /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
