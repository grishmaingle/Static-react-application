# Stage 1: Build the React app
FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve with nginx, update Alpine packages for security fixes
FROM nginx:1.25.2-alpine

# Update Alpine packages including curl and libcrypto to fixed versions
RUN apk update && apk upgrade curl libcrypto3 && apk cache clean

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
