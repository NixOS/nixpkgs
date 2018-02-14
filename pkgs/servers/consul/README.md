# Updating consul

When updating consul, you must also update `consul-ui`'s Ruby dependencies.

Do so by downloading the source code, `cd ui`, and run

```bash
cd TEMP_DIR_WITH_CONSUL_SOURCE
cd ui
$(nix-build '<nixpkgs>' -A bundix --no-out-link)/bin/bundix --magic
cp gemset.nix Gemfile Gemfile.lock THIS_DIRECTORY
```

(As described in https://nixos.org/nixpkgs/manual/#sec-language-ruby)
