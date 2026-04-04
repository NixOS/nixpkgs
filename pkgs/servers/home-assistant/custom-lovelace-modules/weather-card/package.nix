{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "weather-card";
  version = "2.0.0b0";

  src = fetchFromGitHub {
    owner = "bramkragten";
    repo = "weather-card";
    tag = "v${version}";
    hash = "sha256-139OhAHxulXovyywBuz552lmDqoV7aLHKKNb81dOKDo=";
  };
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/weather-card.js $out/

    runHook postInstall
  '';

  meta = {
    description = "Weather Card with animated icons for Home Assistant Lovelace";
    homepage = "https://github.com/bramkragten/weather-card";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.all;
  };
}
