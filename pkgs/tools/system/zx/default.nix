{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "zx";
  version = "8.1.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zx";
    rev = version;
    hash = "sha256-CeFUALi5MXQqd/LwSsyi6sBTFJpZGfCCMuD7Moyk9hM=";
  };

  npmDepsHash = "sha256-yhy2bTXeBYxGaLYb2by+7Y5DfKJ04hroYiOIvwcBojY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for writing scripts using JavaScript";
    homepage = "https://github.com/google/zx";
    changelog = "https://github.com/google/zx/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jlbribeiro ];
    mainProgram = "zx";
  };
}
