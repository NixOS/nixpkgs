{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "weather-card";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "bramkragten";
    repo = "weather-card";
    rev = "refs/tags/v${version}";
    hash = "sha256-pod5cayaHP+4vgdBgBRMQ7szkyz9HLaKVJWQX36XdTY=";
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
