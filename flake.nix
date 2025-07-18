{
  description = "CachyOS Proton compatibility layer for Steam Play";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        default = self.packages.${system}.proton-cachyos;
        proton-cachyos = pkgs.callPackage ./default.nix { };
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          curl
          jq
          nix-prefetch-url
        ];
      };
    };
}