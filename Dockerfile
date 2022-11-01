FROM node:16

WORKDIR /app

COPY .yarn yarn.lock .pnp.*js ./
COPY . .

EXPOSE 9209
ENV PM2_HOME=/pm2_home

CMD [ "yarn", "run", "start" ]

