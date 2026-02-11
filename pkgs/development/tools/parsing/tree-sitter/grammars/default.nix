{
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchFromSourcehut,
  nix-update-script,
}:

let
  /**
    Set of grammar sources. See ./grammar-sources.nix to define a new grammar.
  */
  grammar-sources = import ./grammar-sources.nix { inherit lib; };

  /**
    Parse a flakeref style string to { type, owner, repo, ref }

    FIXME: switch to builtins.parseFlakeRef when stable
  */
  parseUrl =
    url:
    let
      parts = lib.match "(.+):([^/]+)/([^/?]+)((/|.+ref=)([^&]+))?" url;
      ref = lib.elemAt parts 5;
    in
    {
      type = lib.elemAt parts 0;
      owner = lib.elemAt parts 1;
      repo = lib.elemAt parts 2;
    }
    // lib.optionalAttrs (ref != null) { inherit ref; };

  /**
    Check if a version attr represents an unstable release.
  */
  isUnstable = version: lib.isList (lib.match ".+-unstable-.+" version);

in

lib.mapAttrs' (
  language: attrs:
  lib.nameValuePair "tree-sitter-${language}" (
    {
      # Default to the source attr name as the language
      inherit language;

      # Insert auto-update support
      passthru.updateScript = nix-update-script {
        extraArgs = [
          "--override-filename"
          "pkgs/development/tools/parsing/tree-sitter/grammars/grammar-sources.nix"
        ]
        ++ (
          if (isUnstable attrs.version) then
            [
              "--version"
              "branch"
            ]
          else
            [
              "--version-regex"
              "^v?(\\d+\\.\\d+\\.\\d+)"
            ]
        );
      };
    }

    # Expand flakeref style shorthand into a source expression
    // lib.optionalAttrs (attrs ? url && attrs ? hash) {
      src =
        let
          source = parseUrl attrs.url;
          fetch = lib.getAttr source.type {
            github = fetchFromGitHub;
            gitlab = fetchFromGitLab;
            sourcehut = fetchFromSourcehut;
            # NOTE: include other types here as required
          };
        in
        fetch {
          inherit (source)
            owner
            repo
            ;
          rev = source.ref or "v${attrs.version}";
          inherit (attrs) hash;
        };
    }
    // removeAttrs attrs [
      "url"
      "hash"
    ]
  )
) grammar-sources
