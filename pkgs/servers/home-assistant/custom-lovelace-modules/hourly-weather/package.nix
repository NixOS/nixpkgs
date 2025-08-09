{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hourly-weather";
  version = "6.7.1";

  src = fetchFromGitHub {
    owner = "decompil3d";
    repo = "lovelace-hourly-weather";
    rev = version;
    hash = "sha256-o2whcxLcPQcSvv9aMpZxAk7iqGez2yqhwdB+zU7OwMY=";
  };

  npmDepsHash = "sha256-C4ca6bTXzNmmzA5yK825JwdOYa3KKtGK+eYuKxgspUY=";

  env.CYPRESS_INSTALL_BINARY = "0";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/hourly-weather.js $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Hourly weather card for Home Assistant. Visualize upcoming weather conditions as a colored horizontal bar";
    homepage = "https://github.com/decompil3d/lovelace-hourly-weather";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.all;
  };
}
