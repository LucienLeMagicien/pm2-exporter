FROM node:16

WORKDIR /app

COPY package.json yarn.lock .yarnrc.yml .yarn .pnp.*js ./
COPY exporter.js .

EXPOSE 9209
ENV PM2_HOME=/pm2_home

CMD [ "yarn", "run", "start" ]

