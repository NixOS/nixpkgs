{
  lib,
  pkgs,
  fetchFromGitHub,
  python3Packages,
  nix-prefetch-scripts,
  runtimeShell,
}:

python3Packages.buildPythonApplication rec {
  pname = "nix-update-source";
  version = "0.7.0";

  src = fetchFromGitHub {
    hash = "sha256-+49Yb+rZ3CzFnwEpwj5xrcMUVBiYOJtCk9YeZ15IM/U=";
    owner = "timbertson";
    repo = "nix-update-source";
    rev = "version-${version}";
  };

  propagatedBuildInputs = [ nix-prefetch-scripts ];

  doCheck = false;

  passthru = {
    # NOTE: `fetch` should not be used within nixpkgs because it
    # uses a non-idiomatic structure. It is provided for use by
    # out-of-tree nix derivations.
    fetch =
      path:
      let
        fetchers = {
          # whitelist of allowed fetchers
          inherit (pkgs) fetchgit fetchurl fetchFromGitHub;
        };
        json = lib.importJSON path;
        fetchFn = builtins.getAttr json.fetch.fn fetchers;
        src = fetchFn json.fetch.args;
      in
      json
      // json.fetch
      // {
        inherit src;
        overrideSrc =
          drv:
          lib.overrideDerivation drv (orig: {
            inherit src;
          });
      };

    updateScript = [
      runtimeShell
      "-c"
      ''
        set -e
        echo
        cd ${toString ./.}
        ${pkgs.nix-update-source}/bin/nix-update-source \
          --prompt version \
          --replace-attr version \
          --set owner timbertson \
          --set repo nix-update-source \
          --set type fetchFromGitHub \
          --set rev 'version-{version}' \
          --nix-literal rev 'version-''${version}'\
          --modify-nix default.nix
      ''
    ];
  };

  meta = {
    homepage = "https://github.com/timbertson/nix-update-source";
    description = "Utility to automate updating of nix derivation sources";
    maintainers = with lib.maintainers; [ timbertson ];
    license = lib.licenses.mit;
    mainProgram = "nix-update-source";
  };
}
