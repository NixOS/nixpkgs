{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hourly-weather";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "decompil3d";
    repo = "lovelace-hourly-weather";
    rev = version;
    hash = "sha256-Iy2PbGUe6ygMI6HzmlgLhK5jtnME5U5zIxt+6+sw0aY=";
  };

  npmDepsHash = "sha256-+tBcLc8YDvyfqyATy9NBblmqgZUsErNk0+mleqEEOdU=";

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
