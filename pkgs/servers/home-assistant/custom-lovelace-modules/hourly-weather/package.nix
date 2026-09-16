{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hourly-weather";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "decompil3d";
    repo = "lovelace-hourly-weather";
    rev = version;
    hash = "sha256-oxC4w8Ieoz2fwqBalPI2jXBlebmEw3+7DFN2ocmVo1s=";
  };

  npmDepsHash = "sha256-m/hXymkNJl6IvGWMLnhVc9i5bDc09+Vzt9kuLY20cpI=";

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
