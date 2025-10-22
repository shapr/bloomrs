{
  description = "bloomrs is a command line bloom filter calculator that outputs colors to an RGB matrix";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay = { url = "github:oxalica/rust-overlay"; };
  };
  outputs = { self, nixpkgs, rust-overlay, ... }:
    let
      system = "x86_64-linux";
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = nixpkgs.legacyPackages;
    in {
      packages.${system}.default =
        let pkgs = import nixpkgs { inherit system; };
        in pkgs.rustPlatform.buildRustPackage {
          pname = "bloomrs";
          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = [ pkgs.libudev-zero ];
          version = "0.1.0";
          cargoLock.lockFile = ./Cargo.lock;
          src = pkgs.lib.cleanSource ./.;

        };
      devShells.${system}.default =
        let pkgs = import nixpkgs {
              inherit system;
              overlays = [ (import rust-overlay) ];
              config.allowUnfree = true;
            };
        in
          pkgs.mkShell {
            libraries = with pkgs; [ libudev-zero ];
            packages = with pkgs; [ rust-bin.stable.latest.default rust-analyzer cargo libudev-zero pkg-config ];
            shellHook = ''
            export PKG_CONFIG_PATH=${pkgs.lib.concatStrings ["${pkgs.libudev-zero}" "/lib/pkgconfig"]}
            '';
            # env = [
            #   {
            #     name = "PKG_CONFIG_PATH";
            #     value = nixpkgs.lib.concatStrings ["${nixpkgs.libudev-zero}" "/lib/pkgconfig"];
            #   }
            # ];
          };
    };
}
