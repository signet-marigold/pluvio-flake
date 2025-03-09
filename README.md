# A nix flake for [Pluvio](https://github.com/signet-marigold/Pluvio)

To test this flake on your system, use the command:

`nix run github:signet-marigold/pluvio-flake`

# Info

## Issues

- Rendering issue fixed
  - add [ environment.variables.WEBKIT_DISABLE_DMABUF_RENDERER = "1"; ] to system flake
  
## Install

add this to your system by adding

```nix
pluvio.url = "github:signet-marigold/pluvio-flake";
```

to your inputs

and

```nix
{ pluvio, ... }@inputs:
```

to your outputs

```nix
{ pluvio, ... }:
{
  environment.systemPackages = [
    pluvio.packages."x86_64-linux".default
  ];
}
```

here is an example of using the flake in it's own module
