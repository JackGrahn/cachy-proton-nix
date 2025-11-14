{
  description = "CachyOS Proton compatibility layer for Steam Play";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system} = {
        default = self.packages.${system}.proton-cachyos-v3;
        proton-cachyos-v3 = pkgs.callPackage ./default.nix { 
          microarch = "v3"; 
        };
        proton-cachyos-v4 = pkgs.callPackage ./default.nix { 
          microarch = "v4"; 
        };
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