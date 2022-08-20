{ lib
, stdenv
, fetchurl
, makeWrapper
, electron
}:

stdenv.mkDerivation rec {
  pname = "heroic-unwrapped";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v${version}/heroic-${version}.tar.xz";
    sha256 = "sha256-KX1NyqpCX0hQfdEBF334I0yhH47He7KFIZSKeyak+ZU=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/Heroic

    cp -r locales $out/share/Heroic
    cp -r resources $out/share/Heroic

    makeWrapper ${electron}/bin/electron $out/bin/heroic \
      --add-flags $out/share/Heroic/resources/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Native GUI Epic Games Launcher for Linux, Windows and Mac";
    homepage = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
