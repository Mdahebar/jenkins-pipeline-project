FROM nginx:alpine
RUN echo "<h1>DevOps CI/CD Pipeline - Version 2.0 Live!</h1>" > /usr/share/nginx/html/index.html
EXPOSE 80
