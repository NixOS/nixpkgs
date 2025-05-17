{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.3";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-HBkHN7c8O07b2ZI6R7KFvdBF5GWuYU6rmisxLMSH5EQ=";
  };
  vendorHash = "sha256-2wJvX6jAjU9iaFMIcC5Qm1agRMPv4fFfsCeTkvXSpYs=";
  pnpmDepsHash = "sha256-uy6uKfZpsFEl2n6zOriRsKwlw3av1f0xBF/CwhWLJMU=";
}
