## About
This is a fork of [@saikatharryc's pm2-prometheus-exporter](https://github.com/saikatharryc/pm2-prometheus-exporter"), which is a fork of [@burningtree's](https://github.com/burningtree/pm2-prometheus-exporter). As such, [the original code](https://github.com/LucienLeMagicien/pm2-exporter/commits/master?after=319ca8c0fc838a6e50c9f14e1ab4f35cccbe7a10+34&branch=master&qualified_name=refs%2Fheads%2Fmaster) is under the ISC license. [My changes](https://github.com/LucienLeMagicien/pm2-exporter/commits?author=LucienLeMagicien) are under the Unlicense.
I'm not making a PR because my needs are pretty specific (no pm2 module, `user` and `pm2_home` tags) and opinionated (yarn 2 with [Zero-Install](https://next.yarnpkg.com/features/zero-installs)).
I didn't change much of the original code since it works fine.

## Usage
### Running it directly
```sh
git clone https://github.com/LucienLeMagicien/pm2-exporter.git
cd ./pm2-exporter
PORT=9209 HOST=localhost yarn run start
```

### Running it under pm2
```sh
git clone https://github.com/LucienLeMagicien/pm2-exporter.git
cd ./pm2-exporter
PORT=9209 HOST=localhost pm2 start --name="pm2-exporter" --node-args='-r ./.pnp.cjs' ./exporter.js
```

### Running it in Docker
```sh
docker run --volume=/home/user1/.pm2:/pm2_home --publish="127.0.0.1:9209:9209" ghcr.io/lucienlemagicien/pm2-exporter:latest
```

### docker-compose.yml
```
  pm2-user1-exporter:
    image: ghcr.io/lucienlemagicien/pm2-exporter:latest
    restart: always
    ports:
      - '127.0.0.1:9209:9209'
    volumes:
      - /home/user1/.pm2:/pm2_home:rw
```

### prometheus scrape job
```yml
  - job_name: pm2-metrics
    static_configs:
      - targets:
          - "localhost:9209" # or "pm2-user1-exporter:9209" if using the above docker-compose
```

