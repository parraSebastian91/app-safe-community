# Stage 0, based on Node.js, to build and compile Angular
FROM node:18-alpine3.17 as node
WORKDIR /app
COPY ./ /app/
RUN npm install
# ARG que obtiene desde CLI configuracion para levantar entornos custom
ARG configuration=production
RUN npm run build --configuration=$configuration
# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:alpine
COPY --from=node /app/dist/app-safe-community /usr/share/nginx/html
# se reemplaza archivo de configuracion de NGINX para reconocer routing de angular como default
COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf