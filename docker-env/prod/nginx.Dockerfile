FROM nginx:alpine

COPY ./docker-env/prod/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443