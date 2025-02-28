{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "frigate-hass-card";
  version = "6.3.4";

  # TODO: Migrate to fetchFromGitHub when yarn berry lock format is supported
  src = fetchzip {
    url = "https://github.com/dermotduffy/frigate-hass-card/releases/download/v${version}/frigate-hass-card.zip";
    hash = "sha256-s15+FNfXFYeT7/5x/MMKeRIYhzY/j5qxgsye9FNkXcY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp * $out/

    runHook postInstall
  '';

  meta = {
    description = "A Lovelace card for Frigate in Home Assistant";
    homepage = "https://github.com/dermotduffy/frigate-hass-card";
    changelog = "https://github.com/dermotduffy/frigate-hass-card/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nealfennimore ];
  };
}
