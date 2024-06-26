{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "13.1.2";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-2G6I6Tx6LqgZ5EpVw4ux/JXv+Iky6Coenbh51JoFg7Q=";
  };

  npmDepsHash = "sha256-L6abWbSnxY6gGMXBjxobEg8cpl0p3lMST9T42QGk4yM=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Makes eslint the fastest linter on the planet";
    homepage = "https://github.com/mantoni/eslint_d.js";
    license = licenses.mit;
    maintainers = [ maintainers.ehllie ];
    mainProgram = "eslint_d";
  };
}
