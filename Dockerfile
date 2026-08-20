FROM registry.access.redhat.com/ubi9/nginx-124
COPY . /opt/app-root/src/
CMD ["nginx", "-g", "daemon off;"]
