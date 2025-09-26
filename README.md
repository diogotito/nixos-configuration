# NixOS configuration

This is a flake, so the best way to rebuild the OS is:

```sh
sudo nixos-rebuild switch --flake .#nixos-desktop
```

and to update the packages:

```sh
nix flake --update
```

## Links

- https://github.com/vimjoyer/flake-starter-config
