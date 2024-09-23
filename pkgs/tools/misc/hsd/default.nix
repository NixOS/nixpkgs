{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, python3
, unbound
, cctools
}:

buildNpmPackage rec {
  pname = "hsd";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "handshake-org";
    repo = "hsd";
    rev = "v${version}";
    hash = "sha256-T57kDEQwHIyW7xVXrzjJdUcocST9ks4x3JR8yytH8P4=";
  };

  npmDepsHash = "sha256-EBrCuRckBg42k6ZUoB25xObv3lULnSPNJ2nO9l/TWvA=";

  nativeBuildInputs = [
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    cctools
  ];

  buildInputs = [
    unbound
  ];

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/handshake-org/hsd/blob/${src.rev}/CHANGELOG.md";
    description = "Implementation of the Handshake protocol";
    homepage = "https://github.com/handshake-org/hsd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ d-xo ];
  };
}
