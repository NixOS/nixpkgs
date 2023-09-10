{ fetchFromGitHub
, stdenv
, lib
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "mvebu64boot";
  version = "unstable-2022-10-20";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "mvebu64boot";
    rev = "e7ca70eff2dc278607cc07f6654bbddacb2e4ff6";
    hash = "sha256-Y2yVr/BuOah5yMvF5EvM7frEUY8r+Hf4bNIKVkHgvQs=";
  };

  buildInputs = [
    ncurses
  ];

  installPhase = ''
    runHook preInstall
    install -D mvebu64boot $out/bin/mvebu64boot
    runHook postInstall
  '';

  meta = with lib; {
    description = "Boot 64-bit Marvell EBU SoC over UART";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.all;
  };
}
