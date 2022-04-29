{ lib, fetchurl, appimageTools, gsettings-desktop-schemas, gtk3 }:

let
  version = "2.3.2";
  src = fetchurl {
    # mirror of https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage
    url = "https://archive.org/download/unity-hub-${version}/UnityHub.AppImage";
    sha256 = "07nfyfp9apshqarc6pgshsczila6x4943hiyyizc55kp85aw0imn";
  };
  name = "unityhub";
in appimageTools.wrapType2 rec {
  inherit name src;

  extraPkgs = (pkgs: with pkgs; with xorg; [ gtk2 gdk-pixbuf glib libGL libGLU nss nspr
    alsa-lib cups libcap fontconfig freetype pango
    cairo dbus dbus-glib libdbusmenu libdbusmenu-gtk2 expat zlib libpng12 udev tbb
    libpqxx gtk3 libsecret lsb-release openssl nodejs ncurses5

    libX11 libXcursor libXdamage libXfixes libXrender libXi
    libXcomposite libXext libXrandr libXtst libSM libICE libxcb

    libselinux pciutils libpulseaudio libxml2 icu clang cacert
  ]);

  extraInstallCommands =
    let appimageContents = appimageTools.extractType2 { inherit name src; }; in
    ''
      install -Dm444 ${appimageContents}/unityhub.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/unityhub.desktop \
        --replace 'Exec=AppRun' 'Exec=${name}'
      install -m 444 -D ${appimageContents}/unityhub.png \
        $out/share/icons/hicolor/64x64/apps/unityhub.png
    '';

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  meta = with lib; {
    homepage = "https://unity3d.com/";
    description = "Game development tool";
    longDescription = ''
      Popular development platform for creating 2D and 3D multiplatform games
      and interactive experiences.
    '';
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ tesq0 ];
  };
}
