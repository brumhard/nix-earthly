VERSION 0.6
FROM nixos/nix

nix:
    WORKDIR /nixshizzel
    COPY flake.nix flake.lock .
    RUN nix --extra-experimental-features "nix-command flakes" profile install .#ci
    # simulate shellHook, only thing not working are env vars
    RUN setup-shell

release:
    FROM +nix
    RUN goreleaser --help