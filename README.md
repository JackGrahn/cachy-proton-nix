# CachyOS Proton for Nix

> **Note**: This is a personal flake created for experimenting with Nix packaging. Use at your own discretion.

A Nix flake that packages the latest [CachyOS Proton](https://github.com/CachyOS/proton-cachyos) compatibility layer for Steam Play.

## About

This flake uses stable naming conventions so that compatibility tool names in Steam and Lutris remain consistent across updates. Previously, version dates were included in the package names (e.g., `proton-cachyos-10.0-20251107-slr`), which meant you had to manually select the new version in steam settings after each update. Now, the packages are named `proton-cachyos-v3` and `proton-cachyos-v4`, so updates happen seamlessly without requiring manual intervention.

Since CachyOS started compiling Proton for both x86-64-v3 and x86-64-v4 microarchitectures, this flake now provides both variants. Here is what cachy says about V4 "This release includes a x86_64_v4 package. This package is largely untested and experimental.
It may exhibit issues or completely refuse to work. Use at your own discretion and report issues [here](https://github.com/CachyOS/proton-cachyos/issues/51) only."

## Features
- V3 and V4 microarchitecture versions available
- Stable naming that persists across updates
- Automatically tracks the latest CachyOS Proton releases
- Daily GitHub Actions workflow to check for updates
- Simple flake-based installation

## Usage

### With Nix Flakes

This flake should not be installed as a package directly. Only use it through the appropriate Nix options. A Steam example is shown below.

### NixOS Configuration

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cachy-proton.url = "github:jackgrahn/cachy-proton-nix";
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = [
      inputs.cachy-proton.packages.x86_64-linux.proton-cachyos-v3
      inputs.cachy-proton.packages.x86_64-linux.proton-cachyos-v4
    ];
  };
}
```

## Updates

This flake automatically checks for new CachyOS Proton releases daily and creates pull requests when updates are available.

## License

This packaging is provided under the MIT license. CachyOS Proton itself may contain proprietary components.