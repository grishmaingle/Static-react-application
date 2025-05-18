# Stage 1: Build the React app
FROM node:20-alpine3.21.4 AS build

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source files and build
COPY . .
RUN npm run build

# Stage 2: Serve the app using Nginx
FROM nginx:alpine3.21

# Update packages and patch vulnerabilities
RUN apk update && apk upgrade && \
    rm -rf /var/cache/apk/*

# Remove default Nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy built React app to Nginx static directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 and run Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
