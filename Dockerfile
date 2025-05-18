## Stage 1: Build the React app
FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve with nginx (Debian-based image)
FROM nginx:1.25.2

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy React build output (default folder is 'build')
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
