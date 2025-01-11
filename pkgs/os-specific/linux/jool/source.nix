{ fetchFromGitHub }:

rec {
  version = "4.1.13";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "refs/tags/v${version}";
    hash = "sha256-Uls3S53jdoGyJ5xUEipQ0Ev5LAp5wzF2DsaLZCy+6Gc=";
  };
}
