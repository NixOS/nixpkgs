# Packaging guidelines

## Entrypoint

Every lovelace module has an entrypoint in the form of a `.js` file. By
default the nixos module will try to load `${pname}.js` when a module is
configured.

The entrypoint used can be overridden in `passthru` like this:

```nix
passthru.entrypoint = "demo-card-bundle.js";
```
