{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    # Systems supported
    allSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = f:
      nixpkgs.lib.genAttrs allSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    packages = forAllSystems ({pkgs}: {
      default = pkgs.python3Packages.callPackage (import ./arc-overhang.nix) {};
    });

    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        packages = [(pkgs.python3Packages.callPackage (import ./arc-overhang.nix) {})];
      };
    });
  };
}
