{ stdenv
, fetchurl
, appimageTools
, makeWrapper
, electron_9
, openssl
}:

let
  electron = electron_9;

in

stdenv.mkDerivation rec {
  pname = "1password";
  version = "0.9.3";

  src = fetchurl {
    url = "https://onepassword.s3.amazonaws.com/linux/appimage/${pname}-${version}.AppImage";
    sha256 = "wO1HwXl6Lf7+2fXX7i8nrD/hi9dAWn50Jkoztx6aT0Q=";
  };

  nativeBuildInputs = [ makeWrapper ];

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = let
    runtimeLibs = [
      openssl.out
      stdenv.cc.cc
    ];
  in ''
    mkdir -p $out/bin $out/share/1password

    # Applications files.
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}

    # Desktop file.
    install -Dt $out/share/applications ${appimageContents}/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    # Icons.
    cp -a ${appimageContents}/usr/share/icons $out/share

    # Wrap the application with Electron.
    makeWrapper "${electron}/bin/electron" "$out/bin/${pname}" \
      --add-flags "$out/share/${pname}/resources/app.asar" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath runtimeLibs}"
  '';

  passthru.updateScript = ./update.sh;

  meta = with stdenv.lib; {
    description = "Multi-platform password manager";
    longDescription = ''
      1Password is a multi-platform package manager.

      The Linux version is currently a development preview and can
      only be used to search, view, and copy items. However items
      cannot be created or edited.
    '';
    homepage = "https://1password.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ danieldk timstott ];
    platforms = [ "x86_64-linux" ];
  };
}
