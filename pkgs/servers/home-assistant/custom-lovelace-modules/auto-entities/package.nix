{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "auto-entities";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-auto-entities";
    tag = "v${version}";
    hash = "sha256-dGTbF7KO59Flw470i5U+0/ROEZYKe0KH9Y2R4JVyvd8=";
  };

  npmDepsHash = "sha256-OvXlCqD9KI4D9xsTY7morOzXsB+3w12METm2uvcO9h8=";

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
