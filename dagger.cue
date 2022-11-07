package main

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
    "universe.dagger.io/docker/cli"
)

dagger.#Plan & {
	client: {
		filesystem: ".": read: contents: dagger.#FS
		network: "unix:///var/run/docker.sock": connect: dagger.#Socket
		env: {
			REGISTRY_USER: string
			REGISTRY_PASS: dagger.#Secret
		}
	}

	actions: {
		build: docker.#Dockerfile & {
			// This is the Dockerfile context
			source: client.filesystem.".".read.contents
		}

		// Load the built image in the local docker engine
		"docker-local-load": cli.#Load & {
			image: build.output
			host:  client.network."unix:///var/run/docker.sock".connect
			tag:   "pm2-exporter"
		}

		push: docker.#Push & {
			image: build.output
			dest:  "ghcr.io/lucienlemagicien/pm2-exporter:latest"
			auth: {
				username: client.env.REGISTRY_USER
				secret:   client.env.REGISTRY_PASS
			}
		}
	}
}
