{ lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "lint-staged";
  version = "13.0.3";

  src = fetchFromGitHub {
    owner = "okonet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gQrgDX0+fpLz4Izrw29ChwBUXXXrUyZqV7BWtz9Ru8k=";
  };

  npmDepsHash = "sha256-n8UAupSb8fA+1oemKAVZEGs024ToRTNUTWKz1V88I/o=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Run linters on git staged files";
    homepage = "https://github.com/okonet/lint-staged";
    license = licenses.mit;
    maintainers = with maintainers; [ montchr ];
  };
}
