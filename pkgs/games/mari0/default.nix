{ lib, stdenv, fetchFromGitHub, zip, love, makeWrapper, makeDesktopItem
, copyDesktopItems }:

stdenv.mkDerivation rec {
  pname = "mari0";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "Stabyourself";
    repo = pname;
    rev = version;
    sha256 = "1zqaq4w599scsjvy1rsb21fd2r8j3srx9vym4ir9bh666dp36gxa";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems zip ];

  desktopItems = [
    (makeDesktopItem {
      name = "mari0";
      exec = pname;
      comment = "Crossover between Super Mario Bros. and Portal";
      desktopName = "mari0";
      genericName = "mari0";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    zip -9 -r mari0.love ./*
    install -Dm444 -t $out/share/games/lovegames/ mari0.love
    makeWrapper ${love}/bin/love $out/bin/mari0 \
      --add-flags $out/share/games/lovegames/mari0.love
    runHook postInstall
  '';

  meta = with lib; {
    description = "Crossover between Super Mario Bros. and Portal";
    platforms = platforms.linux;
    license = licenses.mit;
    downloadPage = "https://stabyourself.net/mari0/";
  };

}
