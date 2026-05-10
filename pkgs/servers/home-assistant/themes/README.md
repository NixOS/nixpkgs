# Packaging guidelines

## isHomeAssistantTheme

The nixos module checks for `passthru.isHomeAssistantTheme` on every
package passed to `services.home-assistant.themes`, and rejects packages
that don't have it set. Mark a theme package like this:

```nix
{ passthru.isHomeAssistantTheme = true; }
```

Themes are expected to install their `.yaml` files into `$out/themes/`.
