{ cctools
, buildNpmPackage
, fetchFromGitHub
, lib
, python3
, stdenv
}:

buildNpmPackage rec {
  pname = "semantic-release";
  version = "23.0.0";

  src = fetchFromGitHub {
    owner = "semantic-release";
    repo = "semantic-release";
    rev = "v${version}";
    hash = "sha256-UXh/3ziNuTvLjd54l7oUOZgbu0+Hy4+a5TUp9dEvAJw=";
  };

  npmDepsHash = "sha256-RgqerFVG0qdJ52zTvsgtczGcdKw6taiIpgA2LHPELws=";

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
