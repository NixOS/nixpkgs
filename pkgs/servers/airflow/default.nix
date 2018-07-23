{ lib, stdenv, pkgs }:

let
	deps = import ./requirements.nix { inherit pkgs; };
in deps.packages.apache-airflow.override (p: {
  meta = p.meta // {
    maintainers = [lib.maintainers.offline];
  };
})
