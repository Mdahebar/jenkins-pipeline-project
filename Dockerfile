# Base image: standard lightweight web server
FROM nginx:alpine

# Custom HTML page copy karna container ke andar
RUN echo "<h1>DevOps CI/CD Pipeline - Docker Build v1.0</h1>" > /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80
