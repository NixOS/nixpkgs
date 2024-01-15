{ lib, stdenv, fetchFromGitHub
, ffmpeg
, imagemagick
, makeWrapper
, mplayer
}:

stdenv.mkDerivation rec {
  pname = "gopro";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "KonradIT";
    repo = "gopro-linux";
    rev = version;
    sha256 = "0sb9vpiadrq8g4ag828h8mvq01fg0306j0wjwkxdmwfqync1128l";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 gopro -t $out/bin
    wrapProgram $out/bin/gopro \
      --prefix PATH ":" "${lib.makeBinPath [ ffmpeg imagemagick mplayer ]}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line interface for processing media filmed on GoPro HERO 3, 4, 5, 6, and 7 cameras";
    homepage = "https://github.com/KonradIT/gopro-linux";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jonringer ];
    mainProgram = "gopro";
  };
}
