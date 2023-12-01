{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "maizzle";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "maizzle";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-6AV5irttsI76CQH0GixnCufZ35Il+JQjy3hkK9Iktbo=";
  };

  npmDepsHash = "sha256-DeAV3uOo5UpSX0RP0cIb6IwS759PLKK0DtguQH3m73M=";

  dontNpmBuild = true;

  meta = {
    description = "CLI tool for the Maizzle Email Framework";
    homepage = "https://github.com/maizzle/cli";
    license = lib.licenses.mit;
    mainProgram = "maizzle";
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
