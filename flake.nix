{
  description = "local development setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        overallPkgs = with pkgs;[
          go_1_19
        ];
        shellHook = ''
          echo "entering your env"
          echo "do some setup here"
          export TESTING_LEL="testststtst"
          ${pkgs.go_1_19}/bin/go version
        '';
      in
      rec{
        packages = {
          default = packages.local;
          local = pkgs.buildEnv {
            name = "my-tools";
            paths = with pkgs; overallPkgs ++ [
              earthly
            ];
          };
          ci = pkgs.buildEnv {
            name = "my-tools";
            paths = with pkgs; overallPkgs ++ [
              goreleaser # only for CI
              # hack to share shellHook with container
              (pkgs.writeScriptBin "setup-shell" shellHook)
            ];
          };
        };
        devShell = pkgs.mkShell {
          inherit shellHook;
          packages = [ packages.local ];
        };
      }
    );
}
