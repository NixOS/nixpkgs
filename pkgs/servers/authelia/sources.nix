{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.38.19";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-VqdSDrvsue8NqUNN5H++psxAyvvSyFNqt2U8yUXhTo8=";
  };
  vendorHash = "sha256-NONSCqRalxZq1n0Q3fXKVXpkALkoyIl3+Fsx7Xb3M2w=";
  pnpmDepsHash = "sha256-9ZqAoktMS28GTqbOsWDYUsS1H0unWSEPO0Z2b5xXV54=";
}
