{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "zx";
  version = "8.1.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    rev = version;
    hash = "sha256-tv66idt+IfELc5TpMwDujJeIOi+kxFSl3RX3SrYL9ac=";
  };

  npmDepsHash = "sha256-WZJDbdqoy/JkKAR00nG4IdM6okHLsqfudHw0Gs+WntM=";

  meta = {
    description = "Tool for writing scripts using JavaScript";
    homepage = "https://github.com/google/zx";
    changelog = "https://github.com/google/zx/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hlolli ];
    mainProgram = "zx";
  };
}
