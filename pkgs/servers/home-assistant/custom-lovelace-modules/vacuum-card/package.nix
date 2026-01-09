{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "vacuum-card";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = "vacuum-card";
    rev = "v${version}";
    hash = "sha256-3FhlcZVI1M8Ci2C/exwYvlHUBXlGAIFT/1jL6Dl72Ns=";
  };

  npmDepsHash = "sha256-eTFwW/vo+h7Dz7cow2A06M6cc1Ha9eSmDTXEI8WzCdk=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/vacuum-card.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "vacuum-card.js";

  meta = {
    description = "Vacuum cleaner card for Home Assistant Lovelace UI";
    homepage = "https://github.com/denysdovhan/vacuum-card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ baksa ];
    platforms = lib.platforms.all;
  };
}
