# Tree-sitter Grammars

Use [grammar-sources.nix](grammar-sources.nix) to define tree-sitter grammar sources.

Tree-sitter grammars follow a common form for compatibility with the [`tree-sitter` CLI](https://tree-sitter.github.io/tree-sitter/cli/index.html).
This uniformity enables consistent packaging through shared tooling.

## Adding a Grammar

To declare a new package, map the language name to a set of metadata required for the build.
At a minimum, this must include the `version` and `src`.

You may use a shorthand [flakeref](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-flake#url-like-syntax) style `url` and `hash` for concise declarations.
If the hash is not yet known, use a [fake hash placeholder](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-fetchers-updating-source-hashes).

```nix
{
  latex = {
    version = "0.42.0";
    url = "github:vandelay-industries/tree-sitter-latex";
    hash = "";
  };
}
```

This will expand to an element in `pkgs.tree-sitter.grammars` at build time:

```nix
{
  tree-sitter-latex = {
    language = "latex";
    version = "0.42.0";
    src = fetchFromGitHub {
      owner = "vandelay-industries";
      repo = "tree-sitter-latex";
      ref = "v0.42.0";
      hash = "";
    };
  };
}
```

Each entry is passed to [buildGrammar](../build-grammar.nix), which in turn populates `pkgs.tree-sitter-grammars`.

Attempt to build the new grammar: `nix-build -A tree-sitter-grammars.tree-sitter-latex`.
This will fail due to the invalid hash.
Review the downloaded source, then update the source definition with the printed source `hash`.

## Pinning Grammar Sources

To pin to a specific ref, append this to the source `url` to override the default version tag.

```nix
{
  latex = {
    version = "0.42.0";
    url = "github:vandelay-industries/tree-sitter-latex/ccfd77db0ed799b6c22c214fe9d2937f47bc8b34";
    hash = "";
  };
}
```

This may be either a commit hash or tag.

## Supported sources

The `url` field supports the following prefixes:

- `github:` → uses `fetchFromGitHub`
- `gitlab:` → uses `fetchFromGitLab`
- `sourcehut:` → uses `fetchFromSourcehut`

To use [other fetchers](https://nixos.org/manual/nixpkgs/unstable/#chap-pkgs-fetchers), specify the `src` attribute directly:

```nix
{
  foolang = {
    version = "0.42.0";
    src = fetchtorrent {
      config = {
        peer-limit-global = 100;
      };
      url = "magnet:?xt=urn:btih:dd8255ecdc7ca55fb0bbf81323d87062db1f6d1c";
      hash = "";
    };
  };
}
```

## Modifying Build Behaviour

Additional attributes in the grammar definition are forwarded to `buildGrammar`, and then to `mkDerivation`.
This includes build-related flags and metadata.

```nix
{
  foolang = {
    version = "1729.0.0";
    url = "sourcehut:~example/tree-sitter-foolang";
    hash = "";
    generate = true;
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        kimburgess
      ];
    };
  };
}
```

## Updating

All grammar sources have a default update script defined.
To manually trigger an update of a specific grammar definition:

```shell
nix-shell maintainers/scripts/update.nix --argstr package tree-sitter-grammars.tree-sitter-${name}
```

Or, to update all grammars:

```shell
nix-shell maintainers/scripts/update.nix --argstr path tree-sitter-grammars --argstr keep-going true
```

