{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, alsa-lib
, cups
, libX11
, libXScrnSaver
, libXtst
, mesa
, nss
, systemd
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "tetrio-desktop";
  version = "8.0.0";

  src = fetchurl {
    url = "https://web.archive.org/web/20211130172544/https://tetr.io/about/desktop/builds/TETR.IO%20Setup.deb";
    name = "tetrio-desktop.deb";
    sha256 = "1nlblfhrph4cw8rpic9icrs78mzrxyskl7ggyy2i8bk9i07i21xf";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    alsa-lib
    cups
    libX11
    libXScrnSaver
    libXtst
    mesa
    nss
  ];

  dontWrapGApps = true;

  libPath = lib.makeLibraryPath [
    alsa-lib
    cups
    libX11
    libXScrnSaver
    libXtst
    mesa
    nss
    systemd
  ];

  unpackPhase = ''
    mkdir -p $TMP/tetrio-desktop $out/bin
    cp $src $TMP/tetrio-desktop.deb
    ar vx $TMP/tetrio-desktop.deb
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/tetrio-desktop/
  '';

  installPhase = ''
    cp -R $TMP/tetrio-desktop/{usr/share,opt} $out/

    wrapProgram $out/opt/TETR.IO/tetrio-desktop \
      --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/TETR.IO

    ln -s $out/opt/TETR.IO/tetrio-desktop $out/bin/

    substituteInPlace $out/share/applications/tetrio-desktop.desktop \
      --replace "Exec=\"/opt/TETR.IO/tetrio-desktop\"" "Exec=\"$out/opt/TETR.IO/tetrio-desktop\""
  '';

  meta = with lib; {
    homepage = "https://tetr.io";
    downloadPage = "https://tetr.io/about/desktop/";
    description = "TETR.IO desktop client";
    longDescription = ''
      TETR.IO is a modern yet familiar online stacker.
      Play against friends and foes all over the world, or claim a spot on the leaderboards - the stacker future is yours!
    '';
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ wackbyte ];
  };
}
