{ cctools
, buildNpmPackage
, fetchFromGitHub
, lib
, python3
, stdenv
}:

buildNpmPackage rec {
  pname = "semantic-release";
  version = "21.0.5";

  src = fetchFromGitHub {
    owner = "semantic-release";
    repo = "semantic-release";
    rev = "v${version}";
    hash = "sha256-QFBYIoOd1htSNj3xKl0HvmD1T068Jv+L/EqCbMrn0lw=";
  };

  npmDepsHash = "sha256-0GhDXGyVoMwz+vVFdplv7ObTiTRTvQDd9r9e6616iTI=";

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
