{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, python3
, unbound
, darwin
}:

buildNpmPackage rec {
  pname = "hsd";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "handshake-org";
    repo = "hsd";
    rev = "v${version}";
    hash = "sha256-4dWCCybhcdrkLFqUVTajRMnhzNgjpXUN2a+TNIi+Dqo=";
  };

  npmDepsHash = "sha256-ZbBu9hnRsC9LrHozny3OlHhgcDbp6ACjXRV4UHneHQc=";

  nativeBuildInputs = [
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.cctools
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
