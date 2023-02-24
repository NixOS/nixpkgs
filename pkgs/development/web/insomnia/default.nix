{ lib, stdenv, makeWrapper, fetchurl, dpkg, alsa-lib, atk, cairo, cups, dbus, expat
, fontconfig, freetype, gdk-pixbuf, glib, pango, mesa, nspr, nss, gtk3
, at-spi2-atk, gsettings-desktop-schemas, gobject-introspection, wrapGAppsHook
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb, libxshmfence, nghttp2
, libudev0-shim, glibc, curl, openssl, autoPatchelfHook ,undmg ,xar ,cpio
}:

let
  runtimeLibs = lib.makeLibraryPath [
    curl
    glibc
    libudev0-shim
    nghttp2
    openssl
  ];

  pname = "insomnia";
  version = "2022.7.5";
  nameApp = "Insomnia";

  meta = with lib; {
    homepage = "https://insomnia.rest/";
    description = "The most intuitive cross-platform REST API Client";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ markus1189 babariviere ];
  };

  src = if stdenv.hostPlatform.system == "x86_64-linux" then fetchurl {
    url =
      "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.deb";
    sha256 = "sha256-BJAiDv+Zg+wU6ovAkuMVTGN9WElOlC96m/GEYrg6exE=";
  } else if stdenv.isDarwin then fetchurl {
    url =
      "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.dmg";
    sha256 = "sha256-sAsSuCMFJL41GRGdXJgECPVKcCHkDM3lVHYiSqkM/K8=";
  } else throw "Not supported on ${stdenv.hostPlatform.system}.";

  linux = stdenv.mkDerivation rec {
    inherit pname version src;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
      gobject-introspection
      wrapGAppsHook
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      pango
      gtk3
      gsettings-desktop-schemas
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXtst
      libxcb
      libxshmfence
      mesa # for libgbm
      nspr
      nss
    ];

    dontBuild = true;
    dontConfigure = true;
    dontWrapGApps = true;

    unpackPhase = "dpkg-deb -x $src .";

    installPhase = ''
      mkdir -p $out/share/insomnia $out/lib $out/bin

      mv usr/share/* $out/share/
      mv opt/Insomnia/* $out/share/insomnia

      ln -s $out/share/insomnia/insomnia $out/bin/insomnia
      sed -i 's|\/opt\/Insomnia|'$out'/bin|g' $out/share/applications/insomnia.desktop
    '';

    preFixup = ''
      wrapProgram "$out/bin/insomnia" --prefix LD_LIBRARY_PATH : ${runtimeLibs}
    '';

    meta = meta // { platforms = lib.platforms.darwin; };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src;

    # Archive extraction via undmg fails for this particular version.
    nativeBuildInputs = [ makeWrapper undmg ];

    sourceRoot = "${nameApp}.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{Applications/${nameApp}.app,bin}
      cp -R . $out/Applications/${nameApp}.app
      makeWrapper $out/Applications/${nameApp}.app/Contents/MacOS/Insomnia $out/bin/${pname}
      runHook postInstall
    '';

    meta = meta // { platforms = lib.platforms.darwin; };
  };
in
if stdenv.isDarwin then darwin else linux
