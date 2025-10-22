{
  description = "My Cool Rust App";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.rustc pkgs.cargo pkgs.rust-analyzer pkgs.libudev-zero ];
        # env.env = [
        #   {
        #     name = "PKG_CONFIG_PATH";
        #     value = nixpkgs.lib.concatStrings ["${nixpkgs.libudev-zero}" "/lib/pkgconfig"];
        #   }
        # ];
      };
      packages.${system}.default = pkgs.rustPlatform.buildRustPackage {
        pname = "bloomrs";
        nativeBuildInputs = [ nixpkgs.pkg-config ];
        # buildInputs = [ nixpkgs.libudev-zero ];
        version = "0.1.0";
        cargoLock.lockFile = ./Cargo.lock;
        src = pkgs.lib.cleanSource ./.;
      };
    };
}
