FROM registry.access.redhat.com/ubi9/nodejs-20 AS builder
WORKDIR /opt/app-root/src
COPY package*.json ./
RUN npm ci
COPY . .
RUN npx ng build --configuration production

FROM registry.access.redhat.com/ubi9/nginx-124
COPY --from=builder /opt/app-root/src/dist/sigd/browser /opt/app-root/src/
COPY nginx.conf /opt/app-root/etc/nginx.d/default.conf
CMD ["nginx", "-g", "daemon off;"]
