FROM node:18-alpine AS builder

RUN apk update && apk upgrade libxml2

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
FROM nginx:stable-alpine

# Copy custom nginx config (optional but recommended)
COPY nginx.conf /etc/nginx/nginx.conf

# Remove default static assets and add our build
RUN rm -rf /usr/share/nginx/html/*

# Copy build artifacts from 'dist' folder as you said
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
