FROM node:24

WORKDIR /app

# Directories need to be copied on their own, otherwise Docker will flatten it's content to ./
COPY .yarn ./.yarn
COPY package.json yarn.lock .yarnrc.yml .pnp.*js ./

COPY exporter.js .

EXPOSE 9209
ENV PM2_HOME=/pm2_home

CMD [ "yarn", "run", "start" ]

