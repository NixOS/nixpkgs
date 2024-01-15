{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "npm-check-updates";
  version = "16.14.0";

  src = fetchFromGitHub {
    owner = "raineorshine";
    repo = "npm-check-updates";
    rev = "v${version}";
    hash = "sha256-X8Mu4Fd650H7eA2nfoefmr4jW974qLBLurmj2H4t7xY=";
  };

  npmDepsHash = "sha256-wm7/WlzqfE7DOT0jUTXBivlC9J8dyHa/OVSgi2SdO5w=";

  meta = {
    changelog = "https://github.com/raineorshine/npm-check-updates/blob/${src.rev}/CHANGELOG.md";
    description = "Find newer versions of package dependencies than what your package.json allows";
    homepage = "https://github.com/raineorshine/npm-check-updates";
    license = lib.licenses.asl20;
    mainProgram = "ncu";
    maintainers = with lib.maintainers; [ flosse ];
  };
}
