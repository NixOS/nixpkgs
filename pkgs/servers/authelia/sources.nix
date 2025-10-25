{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.13";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-a7r+qsaeOA8hhZkQYg2opVxEMjkW4g1lPQpAe3P9laY=";
  };
  vendorHash = "sha256-j0PeIa+egybsTKy1FKPvVbK+O8RaldqO2MZddlMymwU=";
  pnpmDepsHash = "sha256-4II+pZsSXL2fQt2QMSTE9GE5WzSjS1Egsyzld1OoJ7g=";
}
