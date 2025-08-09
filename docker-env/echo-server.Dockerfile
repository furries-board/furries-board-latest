FROM node:24.3.0-alpine

WORKDIR /app

COPY ./docker-env/echo-server/package.json /app
RUN npm install -g laravel-echo-server

EXPOSE 6001

CMD ["laravel-echo-server", "start"]
