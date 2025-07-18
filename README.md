# CachyOS Proton for Nix

A Nix flake that packages the latest [CachyOS Proton](https://cachyos.org/) compatibility layer for Steam Play.

## Features

- Automatically tracks the latest CachyOS Proton releases
- Daily GitHub Actions workflow to check for updates
- Simple flake-based installation

## Usage

### With Nix Flakes

```bash
# Test the package
nix run github:jackgrahn/cachy-proton-nix

# Install to your profile
nix profile install github:jackgrahn/cachy-proton-nix
```

### NixOS Configuration

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cachy-proton.url = "github:jackgrahn/cachy-proton-nix";
  };

  outputs = { self, nixpkgs, cachy-proton, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          programs.steam = {
            enable = true;
            extraCompatPackages = [
              cachy-proton.packages.x86_64-linux.proton-cachyos
            ];
          };
        }
      ];
    };
  };
}
```

## Development

```bash
# Enter development shell
nix develop

# Build the package
nix build
```

## Updates

This flake automatically checks for new CachyOS Proton releases daily and creates pull requests when updates are available.

## License

This packaging is provided under the MIT license. CachyOS Proton itself may contain proprietary components.