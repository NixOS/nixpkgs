{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "zx";
  version = "8.1.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    rev = version;
    hash = "sha256-h3osu1FDBZsawXxtSVBDjcIiRdqgElPMBxdx2N4cfeQ=";
  };

  npmDepsHash = "sha256-bijPRIiGNGfbtZiQ5aEVGI3DfYfFeA1YbNCTdljDhfw=";

  meta = {
    description = "Tool for writing scripts using JavaScript";
    homepage = "https://github.com/google/zx";
    changelog = "https://github.com/google/zx/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlbribeiro ];
    mainProgram = "zx";
  };
}
