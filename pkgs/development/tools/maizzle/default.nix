{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "maizzle";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "maizzle";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-HGoqwqO50Y1oZBCVXkgM3NyZu+vPz/iniEH9mm/SQ1I=";
  };

  npmDepsHash = "sha256-vqhuoTtrZYmxameaoOfA9N5QGXzdhT1/tWx70KBk5aI=";

  dontNpmBuild = true;

  meta = {
    description = "CLI tool for the Maizzle Email Framework";
    homepage = "https://github.com/maizzle/cli";
    license = lib.licenses.mit;
    mainProgram = "maizzle";
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
