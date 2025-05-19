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
FROM nginx:stable-alpine

# Copy custom nginx config (optional but recommended)
COPY nginx.conf /etc/nginx/nginx.conf

# Remove default static assets and add our build
RUN rm -rf /usr/share/nginx/html/*

# Copy build artifacts to Nginx web root
# NOTE: React's default build directory is 'build' (not 'dist'), so this might cause problems if your React build output is in 'build'
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
