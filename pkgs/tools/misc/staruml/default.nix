{ stdenv, lib, fetchurl
, dpkg, patchelf, wrapGAppsHook
, hicolor-icon-theme
, gtk3, glib, systemd
, xorg, nss, nspr
, atk, at-spi2-atk, dbus
, gdk-pixbuf, pango, cairo
, expat, libdrm, mesa
, alsa-lib, at-spi2-core, cups }:

let
  LD_LIBRARY_PATH = lib.makeLibraryPath [
    glib gtk3 xorg.libXdamage
    xorg.libX11 xorg.libxcb xorg.libXcomposite
    xorg.libXcursor xorg.libXext xorg.libXfixes
    xorg.libXi xorg.libXrender xorg.libXtst
    nss nspr atk at-spi2-atk dbus
    gdk-pixbuf pango cairo
    xorg.libXrandr expat libdrm
    mesa alsa-lib at-spi2-core
    cups
  ];
in
stdenv.mkDerivation rec {
  version = "4.1.6";
  pname = "staruml";

  src =
    fetchurl {
      url = "https://staruml.io/download/releases-v4/StarUML_${version}_amd64.deb";
      sha256 = "sha256-CUOdpR8RExMLeOX8469egENotMNuPU4z8S1IGqA21z0=";
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
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
