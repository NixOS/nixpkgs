{ fetchFromGitHub }:

rec {
  version = "4.1.10";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "refs/tags/v${version}";
    hash = "sha256-98XbBdSmgcepPZxX6hoPim+18lHLbrjqlbipB92nyAc=";
  };
}
