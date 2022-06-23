ASSETS := $(shell yq e '.assets.[].src' manifest.yaml)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION := $(shell yq e ".version" manifest.yaml)
# ECLAIR_SRC := $(shell find ./eclair/src) eclair/Cargo.toml eclair/Cargo.lock
S9PK_PATH=$(shell find . -name eclair.s9pk -print)

# delete the target of a rule if it has changed and its recipe exits with a nonzero exit status
.DELETE_ON_ERROR:

all: verify

verify: eclair.s9pk $(S9PK_PATH)
	embassy-sdk verify s9pk $(S9PK_PATH)

clean:
	rm -f image.tar
	rm -f eclair.s9pk

eclair.s9pk: manifest.yaml assets/compat/config_spec.yaml assets/compat/config_rules.yaml image.tar instructions.md $(ASSET_PATHS)
	embassy-sdk pack

# image.tar: Dockerfile docker_entrypoint.sh check-web.sh eclair/target/aarch64-unknown-linux-musl/release/eclair
image.tar: Dockerfile docker_entrypoint.sh check-web.sh
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/eclair/main:$(VERSION) --platform=linux/aarch64 -o type=docker,dest=image.tar .

# eclair/target/aarch64-unknown-linux-musl/release/eclair: $(ECLAIR_SRC)
# 	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/eclair:/home/rust/src start9/rust-musl-cross:aarch64-musl cargo build --release
