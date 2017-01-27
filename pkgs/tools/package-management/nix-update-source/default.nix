{ lib, pkgs, fetchFromGitHub, python3Packages, nix-prefetch-scripts }:
python3Packages.buildPythonApplication rec {
  version = "0.2.2";
  name = "nix-update-source-${version}";
  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "nix-update-source";
    rev = "version-${version}";
    sha256 = "0liigkr37ib2xy269bcp53ivpir4mpg6lzwnfrsqc4kbkz3l16gg";
  };
  propagatedBuildInputs = [ nix-prefetch-scripts ];
  passthru = {
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
  };
  meta = {
    description = "Utility to autimate updating of nix derivation sources";
    maintainers = with lib.maintainers; [ timbertson ];
  };
}
