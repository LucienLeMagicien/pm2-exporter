package main

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
	"universe.dagger.io/docker/cli"
)

dagger.#Plan & {
	// The "client" field allows interacting with the local machine.
	// https://docs.dagger.io/1203/client
	client: {
		// In Cue, nested objects with only one property can be written without curly braces {}
		// See https://docs.dagger.io/1215/what-is-cue/#cue-is-a-superset-of-json
		filesystem: ".": read: contents: dagger.#FS
		network: "unix:///var/run/docker.sock": connect: dagger.#Socket
		env: {
			REGISTRY_USER: string
			REGISTRY_PASS: dagger.#Secret
		}
	}


	// Actions are the commands Dagger executes. You can list them with `dagger do --help`.
	// https://docs.dagger.io/1221/action
	actions: {
		// Build the Dockerfile
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

		// Push the built image to the remote github registry (this is for CI)
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
