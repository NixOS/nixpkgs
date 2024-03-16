{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, wrapGAppsHook
, alsa-lib
, cups
, libGL
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
  version = "9.0.0";

  src = fetchurl {
    url = "https://web.archive.org/web/20240309215118if_/https://tetr.io/about/desktop/builds/9/TETR.IO%20Setup.deb";
    name = "tetrio-desktop.deb";
    sha256 = "UriLwMB8D+/T32H4rPbkJAy/F/FFhNpd++0AR1lwEfs=";
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
    libGL
    libpulseaudio
    systemd
  ];

  unpackCmd = "dpkg -x $curSrc src";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r opt/ usr/share/ $out

    mkdir $out/bin
    ln -s $out/opt/TETR.IO/TETR.IO $out/bin/

    substituteInPlace $out/share/applications/TETR.IO.desktop \
      --replace-fail "Exec=/opt/TETR.IO/TETR.IO" "Exec=\"$out/opt/TETR.IO/TETR.IO\""

    runHook postInstall
  '';

  postInstall = lib.strings.optionalString withTetrioPlus ''
    cp ${tetrio-plus} $out/opt/TETR.IO/resources/app.asar
  '';

  postFixup = ''
    wrapProgram $out/opt/TETR.IO/TETR.IO \
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
    mainProgram = "TETR.IO";
  };
}
