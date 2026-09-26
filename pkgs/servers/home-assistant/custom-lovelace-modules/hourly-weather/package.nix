{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hourly-weather";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "decompil3d";
    repo = "lovelace-hourly-weather";
    rev = version;
    hash = "sha256-dNgQzdwOVl+f8Var+233zAR1Nn/qck+Z1qrIba541oU=";
  };

  npmDepsHash = "sha256-l4Ipnzf6izlz2WrC9tVn/LSkX/m8T/rj8WmiXKNkRuU=";

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
