{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "standard";
  version = "17.1.0";

  src = fetchFromGitHub {
    owner = "standard";
    repo = "standard";
    rev = "v${version}";
    hash = "sha256-paLvnwXOeTC4SSc+j/LhMLd4j8FgRa1QzGg6bxtlvTs=";
  };

  npmDepsHash = "sha256-TrU4kGoGD4nbFx1wdNWQlahYFYi2r08NEeCb9xOg3sQ=";

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  dontNpmBuild = true;
  dontNpmPrune = true;

  meta = with lib; {
    description = "JavaScript Style Guide, with linter & automatic code fixer";
    homepage = "https://github.com/standard/standard";
    changelog =
      "https://github.com/standard/standard/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
