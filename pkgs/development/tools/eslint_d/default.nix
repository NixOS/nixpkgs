{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "12.2.1";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-rups2y07Y3GkvGt/T9lPG0NUoCxddp/P9PAYczZYNIw=";
  };

  npmDepsHash = "sha256-enHppjkX1syANgFmfAX+LlISyN5ltADjojjrvukAI+I=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Makes eslint the fastest linter on the planet";
    homepage = "github.com/mantoni/eslint_d.js";
    license = licenses.mit;
    maintainers = [ maintainers.ehllie ];
    mainProgram = "eslint_d";
  };
}
