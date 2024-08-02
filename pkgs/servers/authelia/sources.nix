{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.38.9";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-xhn8+eBf0pF1ujglIoBmj0E1+B3YngEESb/SZlR4Ugk=";
  };
  vendorHash = "sha256-ZdrtP8E65Xyx2Czdh1EvfofVWvBIwLmQ8/Tx3rSsIzs=";
  pnpmDepsHash = "sha256-2kABLWeelTml1tcxcgWLHWv/SNqwGxJB+VExusnd+KI=";
}
