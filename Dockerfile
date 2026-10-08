FROM nginx:alpine
RUN echo "<h1>DevOps CI/CD Pipeline - Version 3.0 (GREEN) Live!</h1>" > /usr/share/nginx/html/index.html
EXPOSE 80
