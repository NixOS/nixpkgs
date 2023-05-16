{ stdenv, lib, fetchurl
<<<<<<< HEAD
, dpkg, wrapGAppsHook
=======
, dpkg, patchelf, wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, hicolor-icon-theme
, gtk3, glib, systemd
, xorg, nss, nspr
, atk, at-spi2-atk, dbus
, gdk-pixbuf, pango, cairo
, expat, libdrm, mesa
<<<<<<< HEAD
, alsa-lib, at-spi2-core, cups
, libxkbcommon }:
=======
, alsa-lib, at-spi2-core, cups }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  LD_LIBRARY_PATH = lib.makeLibraryPath [
    glib gtk3 xorg.libXdamage
    xorg.libX11 xorg.libxcb xorg.libXcomposite
    xorg.libXcursor xorg.libXext xorg.libXfixes
    xorg.libXi xorg.libXrender xorg.libXtst
<<<<<<< HEAD
    xorg.libxshmfence libxkbcommon nss
    nspr atk at-spi2-atk
    dbus gdk-pixbuf pango cairo
=======
    nss nspr atk at-spi2-atk dbus
    gdk-pixbuf pango cairo
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    xorg.libXrandr expat libdrm
    mesa alsa-lib at-spi2-core
    cups
  ];
in
stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "6.0.0";
=======
  version = "4.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "staruml";

  src =
    fetchurl {
<<<<<<< HEAD
      url = "https://files.staruml.io/releases-v6/StarUML_${version}_amd64.deb";
      sha256 = "sha256-g35d9YcZrP4D8X9NU84Fz0qmb/2lUUOuZ30iIwgThA0=";
=======
      url = "https://staruml.io/download/releases-v4/StarUML_${version}_amd64.deb";
      sha256 = "sha256-CUOdpR8RExMLeOX8469egENotMNuPU4z8S1IGqA21z0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

  nativeBuildInputs = [ wrapGAppsHook dpkg ];
  buildInputs = [ glib hicolor-icon-theme ];

  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv opt $out

    mv usr/share $out
    rm -rf $out/share/doc

    substituteInPlace $out/share/applications/staruml.desktop \
      --replace "/opt/StarUML/staruml" "$out/bin/staruml"

    mkdir -p $out/lib
    ln -s ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 $out/lib/
    ln -s ${lib.getLib systemd}/lib/libudev.so.1 $out/lib/libudev.so.0

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/opt/StarUML/staruml

    ln -s $out/opt/StarUML/staruml $out/bin/staruml
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH ':' $out/lib:${LD_LIBRARY_PATH}
    )
  '';

  meta = with lib; {
    description = "A sophisticated software modeler";
    homepage = "https://staruml.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
<<<<<<< HEAD
    maintainers = with maintainers; [ kashw2 ];
=======
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [ "x86_64-linux" ];
  };
}
