{ cctools
, buildNpmPackage
, fetchFromGitHub
, lib
, python3
, stdenv
}:

buildNpmPackage rec {
  pname = "semantic-release";
  version = "23.0.6";

  src = fetchFromGitHub {
    owner = "semantic-release";
    repo = "semantic-release";
    rev = "v${version}";
    hash = "sha256-saWKx7OnKRT1zonaSRaLXUoL7XI6YaeKogdTuxDN6eo=";
  };

  npmDepsHash = "sha256-OvH568kJP0tdK6y2TmMRAyVZ4LgY9+Y4AF39jXk4dq4=";

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
    mainProgram = "semantic-release";
    homepage = "https://semantic-release.gitbook.io/semantic-release/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sestrella ];
  };
}
