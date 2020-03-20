{ stdenv, fetchurl, appimageTools, gsettings-desktop-schemas, gtk3, undmg }:

let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  name = "unityhub";
  appName = "Unity Hub";

  sha256 = {
    x86_64-darwin = "0vra8hllfzh5zpxshwxhqmyb7bm07yzn2gcicqggq5yav758z3wb";
    x86_64-linux = "1rx7ih94ig3pd1yx1d3fpx7zpixq3j5birkpnzkh778qqsdrg0nf";
  }.${system} or throwSystem;

  meta = with stdenv.lib; {
    homepage = https://unity3d.com/;
    description = "Game development tool";
    longDescription = ''
      Popular development platform for creating 2D and 3D multiplatform games
      and interactive experiences.
    '';
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    maintainers = with maintainers; [ tesq0 ];
  };

  linux = appimageTools.wrapType2 rec {
    inherit name meta;

    extraPkgs = (pkgs: with pkgs; with xorg; [ gtk2 gdk_pixbuf glib libGL libGLU nss nspr
      alsaLib cups gnome2.GConf libcap fontconfig freetype pango
      cairo dbus dbus-glib libdbusmenu libdbusmenu-gtk2 expat zlib libpng12 udev tbb
      libpqxx gtk3 libsecret lsb-release openssl nodejs ncurses5

      libX11 libXcursor libXdamage libXfixes libXrender libXi
      libXcomposite libXext libXrandr libXtst libSM libICE libxcb ]);

    profile = ''
      export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
    '';

    src = fetchurl {
      url = "https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage";
      inherit sha256;
    };
  };

  darwin = stdenv.mkDerivation {
    inherit name meta;

    src = fetchurl {
      url = "https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.dmg";
      inherit sha256;
    };

    buildInputs = [ undmg ];
    installPhase = ''
      mkdir -p "$out/Applications/Unity/Hub/${appName}.app"
      cp -R . "$out/Applications/Unity/Hub/${appName}.app"
      chmod a+x "$out/Applications/Unity/Hub/${appName}.app/Contents/MacOS/${appName}"
    '';
  };

in if stdenv.isDarwin
  then darwin
  else linux

