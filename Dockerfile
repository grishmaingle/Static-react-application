# Use official Node image as build stage
FROM node:20-alpine3.21 AS build
RUN apk update && apk upgrade


WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Use nginx to serve static files
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
