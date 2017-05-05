{ lib, pkgs, fetchFromGitHub, python3Packages, nix-prefetch-scripts }:
python3Packages.buildPythonApplication rec {
  version = "0.4.0";
  name = "nix-update-source-${version}";
  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "nix-update-source";
    rev = "version-0.4.0";
    sha256 = "0gz0f7nx1q697s16ya7q84q1cj020n547k2ffb99ds2r40nckr2g";
  };
  propagatedBuildInputs = [ nix-prefetch-scripts ];
  passthru = {
    # NOTE: `fetch` should not be used within nixpkgs because it
    # uses a non-idiomatic structure. It is provided for use by
    # out-of-tree nix derivations.
    fetch = path:
      let
        fetchers = {
          # whitelist of allowed fetchers
          inherit (pkgs) fetchgit fetchurl fetchFromGitHub;
        };
        json = lib.importJSON path;
        fetchFn = builtins.getAttr json.fetch.fn fetchers;
        src = fetchFn json.fetch.args;
      in
      json // json.fetch // { inherit src; };
    updateScript = ''
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
    description = "Utility to automate updating of nix derivation sources";
    maintainers = with lib.maintainers; [ timbertson ];
    license = lib.licenses.mit;
  };
}
