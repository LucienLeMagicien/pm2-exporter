package main

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
)

dagger.#Plan & {
	client: {
		filesystem: ".": read: contents: dagger.#FS
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
