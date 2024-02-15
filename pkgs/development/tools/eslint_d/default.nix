{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-tlpuJ/p+U7DuzEmy5ulY3advKN+1ID9LDjUl8fDANVs=";
  };

  npmDepsHash = "sha256-MiuCupnzMUjwWh47SLnMRmtHBMbXdyjEZwgvaZz4JN0=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Makes eslint the fastest linter on the planet";
    homepage = "https://github.com/mantoni/eslint_d.js";
    license = licenses.mit;
    maintainers = [ maintainers.ehllie ];
    mainProgram = "eslint_d";
  };
}
