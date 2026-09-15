{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hourly-weather";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "decompil3d";
    repo = "lovelace-hourly-weather";
    rev = version;
    hash = "sha256-sy21so7D5IbbiEnt1mAKFhxVJDzMWjOIhSOpGRRyMXk=";
  };

  npmDepsHash = "sha256-ZB/M8SO6Dw523CMKSAisoy5y4r1AouKXLY7Z1lgK4jU=";

  env.CYPRESS_INSTALL_BINARY = "0";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/hourly-weather.js $out

    runHook postInstall
  '';

  meta = {
    description = "Hourly weather card for Home Assistant. Visualize upcoming weather conditions as a colored horizontal bar";
    homepage = "https://github.com/decompil3d/lovelace-hourly-weather";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.all;
  };
}
