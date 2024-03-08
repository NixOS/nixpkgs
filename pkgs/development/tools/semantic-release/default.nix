{ cctools
, buildNpmPackage
, fetchFromGitHub
, lib
, python3
, stdenv
}:

buildNpmPackage rec {
  pname = "semantic-release";
  version = "23.0.2";

  src = fetchFromGitHub {
    owner = "semantic-release";
    repo = "semantic-release";
    rev = "v${version}";
    hash = "sha256-zwc21Ug/x1jP+litn8ij8eEvqpVmtMSiQT3jN4+RhNc=";
  };

  npmDepsHash = "sha256-8iCb6s9VCuXfgU6Qc/bUHMiLgEgreEa7LU0j+1CYVI0=";

  dontNpmBuild = true;

  nativeBuildInputs = [
    python3
  ] ++ lib.optional stdenv.isDarwin cctools;

  # Fixes `semantic-release --version` output
  postPatch = ''
    substituteInPlace package.json --replace \
      '"version": "0.0.0-development"' \
      '"version": "${version}"'
  '';

  meta = {
    description = "Fully automated version management and package publishing";
    homepage = "https://semantic-release.gitbook.io/semantic-release/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sestrella ];
  };
}
