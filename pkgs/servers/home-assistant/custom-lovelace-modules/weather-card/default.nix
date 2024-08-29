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

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/weather-card.js $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Weather Card with animated icons for Home Assistant Lovelace";
    homepage = "https://github.com/bramkragten/weather-card";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.all;
  };
}
