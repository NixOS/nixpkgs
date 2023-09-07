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

  npmDepsHash = "sha256-qYP82/A4Dledo7vCMDgJ6VbZTa4d4qzAM31tBrsC2o4=";

  meta = with lib; {
    description = "JavaScript Style Guide, with linter & automatic code fixer";
    homepage = "https://github.com/standard/standard";
    changelog =
      "https://github.com/standard/standard/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
