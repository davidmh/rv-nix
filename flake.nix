{
  description = "Nix flake for rv: Next-gen very fast Ruby tooling";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    rv-src = {
      flake = false;
      url = "github:spinel-coop/rv/v0.5.3";
    };
  };

  outputs = { nixpkgs, rv-src, rust-overlay, ... }:
    let
      systems = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
      perSystem = system:
        let
          pkgs = import nixpkgs {
            system = system;
            overlays = [ rust-overlay.overlays.default ];
          };
          rv = pkgs.rustPlatform.buildRustPackage {
            pname = "rv";
            version = rv-src.shortRev;
            src = rv-src;
            cargoLock = {
              lockFile = rv-src + "/Cargo.lock";
              outputHashes = {
                "rayon-tracing-0.1.1" = "sha256-aSuVNRcm2Y78V3kqgeOciaHSnGfSTIQPccw4EhAuX6g=";
                "dep-graph-0.2.1" = "sha256-RJocmZQTxKuILEAJcQDSg1F0iD8z5FWEdRB+VcEluXM=";
              };
            };
            cargoBuildFlags = [ "--all-features" ];
            doInstallCheck = true;
            doCheck = false;
            nativeBuildInputs = [ pkgs.rust-bin.stable."1.94.1".default ];
            meta = {
              description = "Next-gen very fast Ruby tooling";
              homepage = "https://github.com/spinel-coop/rv";
              license = pkgs.lib.licenses.mit;
              platforms = pkgs.lib.platforms.unix;
            };
          };
        in
        {
          packages = {
            default = rv;
          };
          devShell = pkgs.mkShell {
            buildInputs = [ rv ];
          };
        };
    in
    {
      packages = builtins.listToAttrs (map
        (system: {
          name = system;
          value = (perSystem system).packages;
        })
        systems);
      devShells = builtins.listToAttrs (map
        (system: {
          name = system;
          value = { default = (perSystem system).devShell; };
        })
        systems);
    };
}
