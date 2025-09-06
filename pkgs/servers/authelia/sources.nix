{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.6";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-u4GXpSBiokzlGxdIsHCqRlqHKSbluErbkWpJ0/ieWRs=";
  };
  vendorHash = "sha256-eTkRc9I/bQkQ5rn54jKS/T0yBs5feAK4MEMzReG/68U=";
  pnpmDepsHash = "sha256-Dvcwzdv72Rx9qS5nmBjxDOlCHWPg9Abas24ecxoTZUc=";
}
