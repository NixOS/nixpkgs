{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "14.0.3";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-r0pb9qbWfyVUHuHrNhiYm+0zlF5WId3dH7QCubzZDts=";
  };

  npmDepsHash = "sha256-0Db18y7MUnnnr8v+bBOUhGBCsZcZ9OGtGqSVH7/wYQc=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Makes eslint the fastest linter on the planet";
    homepage = "https://github.com/mantoni/eslint_d.js";
    license = licenses.mit;
    maintainers = [ maintainers.ehllie ];
    mainProgram = "eslint_d";
  };
}
