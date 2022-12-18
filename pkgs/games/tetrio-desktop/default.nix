{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, alsa-lib
, cups
, libX11
, libXScrnSaver
, libXtst
, mesa
, nss
, gtk3
, libpulseaudio
, systemd
, callPackage
, withTetrioPlus ? false
, tetrio-plus ? callPackage ./tetrio-plus.nix { }
}:

stdenv.mkDerivation rec {
  pname = "tetrio-desktop";
  version = "8.0.0";

  src = fetchurl {
    url = "https://web.archive.org/web/20211228025517if_/https://tetr.io/about/desktop/builds/TETR.IO%20Setup.deb";
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
    gtk3
  ];

  dontWrapGApps = true;

  libPath = lib.makeLibraryPath [
    libpulseaudio
    systemd
  ];

  unpackPhase = ''
    mkdir -p $TMP/tetrio-desktop $out/bin
    cp $src $TMP/tetrio-desktop.deb
    ar vx $TMP/tetrio-desktop.deb
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/tetrio-desktop/
  '';

  installPhase = ''
    runHook preInstall

    cp -R $TMP/tetrio-desktop/{usr/share,opt} $out/
    ln -s $out/opt/TETR.IO/tetrio-desktop $out/bin/

    substituteInPlace $out/share/applications/tetrio-desktop.desktop \
      --replace "Exec=\"/opt/TETR.IO/tetrio-desktop\"" "Exec=\"$out/opt/TETR.IO/tetrio-desktop\""

    runHook postInstall
  '';

  postInstall = lib.strings.optionalString withTetrioPlus ''
      cp ${tetrio-plus} $out/opt/TETR.IO/resources/app.asar
    '';

  postFixup = ''
    wrapProgram $out/opt/TETR.IO/tetrio-desktop \
      --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/TETR.IO \
      ''${gappsWrapperArgs[@]}
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
