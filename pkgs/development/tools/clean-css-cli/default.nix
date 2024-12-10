{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "clean-css-cli";
  version = "5.6.2";

  src = fetchFromGitHub {
    owner = "clean-css";
    repo = "clean-css-cli";
    rev = "v${version}";
    hash = "sha256-ONWJn6mehXeNwRVEEM+Ad/heXwNWC9E9yA5eUQsi98A=";
  };

  npmDepsHash = "sha256-eVd6YSTHhp6qzGYn5PlikUgjNS+GJoRwfm6KPrEJKGE=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/clean-css/clean-css-cli/blob/${src.rev}/History.md";
    description = "Command-line interface to the clean-css CSS optimization library";
    homepage = "https://github.com/clean-css/clean-css-cli";
    license = lib.licenses.mit;
    mainProgram = "cleancss";
    maintainers = with lib.maintainers; [ ];
  };
}
