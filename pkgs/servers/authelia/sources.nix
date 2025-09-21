{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.8";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-FDEIou7XGxNUyryhRK9WwGYxwMFgq5d5GhRBLJhQLSk=";
  };
  vendorHash = "sha256-92U7ih6tIF5Qm/Fio8MHdcWHHxndWf0Y4sxNTc69VZY=";
  pnpmDepsHash = "sha256-XxOgAkByTHmJ4+0aKFgGGfc7g68Xa+fHvdzVGDSJ3go=";
}
