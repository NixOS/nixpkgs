{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "auto-entities";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-auto-entities";
    tag = "v${version}";
    hash = "sha256-yMqf4LA/fBTIrrYwacUTb2fL758ZB1k471vdsHAiOj8=";
  };

  npmDepsHash = "sha256-XLhTLK08zW1BFj/PI8/61FWzoyvWi5X5sEkGlF1IuZU=";

  installPhase = ''
    runHook preInstall

    install -D auto-entities.js $out/auto-entities.js

    runHook postInstall
  '';

  meta = with lib; {
    description = "Automatically populate the entities-list of lovelace cards";
    homepage = "https://github.com/thomasloven/lovelace-auto-entities";
    changelog = "https://github.com/thomasloven/lovelace-auto-entities/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
