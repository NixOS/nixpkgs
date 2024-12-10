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
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "nix-update-source";
    rev = "version-${version}";
    sha256 = "157wvv9vnaszzwbj68jpdc0imcm1hdab3z760bx2axbsgfpqqilz";
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

    updateScript = ''
      #!${runtimeShell}
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
        --modify-nix default.nix
    '';
  };

  meta = {
    homepage = "https://github.com/timbertson/nix-update-source";
    description = "Utility to automate updating of nix derivation sources";
    maintainers = with lib.maintainers; [ timbertson ];
    license = lib.licenses.mit;
    mainProgram = "nix-update-source";
  };
}
