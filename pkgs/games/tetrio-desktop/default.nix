{ stdenv
, lib
, fetchurl
, dpkg
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
    dpkg
    autoPatchelfHook
    wrapGAppsHook
  ];

  dontWrapGApps = true;

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

  libPath = lib.makeLibraryPath [
    libpulseaudio
    systemd
  ];

  unpackCmd = "dpkg -x $curSrc src";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r opt/ usr/share/ $out

    mkdir $out/bin
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
