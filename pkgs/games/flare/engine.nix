{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  Cocoa,
}:

stdenv.mkDerivation rec {
  pname = "flare-engine";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DIzfTqwZJ8NAPB/TWzvPjepHb7hIbIr+Kk+doXJmpLc=";
  };

  patches = [ ./desktop.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
  ] ++ lib.optional stdenv.hostPlatform.isDarwin Cocoa;

  meta = {
    description = "Free/Libre Action Roleplaying Engine";
    homepage = "https://github.com/flareteam/flare-engine";
    maintainers = with lib.maintainers; [
      aanderse
      McSinyx
    ];
    license = [ lib.licenses.gpl3 ];
    platforms = lib.platforms.unix;
  };
}
