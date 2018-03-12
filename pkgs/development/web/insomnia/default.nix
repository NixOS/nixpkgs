{ stdenv, lib, makeWrapper, fetchurl, dpkg,

  alsaLib, atk, cairo, cups, dbus_daemon, expat, fontconfig, freetype, gdk_pixbuf, glib, gnome2, gtk2-x11,
  nspr, nss,

  libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext, libXfixes, libXi, libXrandr,
  libXrender, libXtst, libxcb,

  libudev0-shim, glibc, curl
}:

let
  libPath = lib.makeLibraryPath [
    alsaLib atk cairo cups dbus_daemon.lib expat fontconfig freetype gdk_pixbuf glib gnome2.GConf gnome2.pango
    gtk2-x11 nspr nss stdenv.cc.cc.lib libX11 libXScrnSaver libXcomposite libXcursor libXdamage libXext libXfixes
    libXi libXrandr libXrender libXtst libxcb
  ];
  runtimeLibs = lib.makeLibraryPath [ libudev0-shim glibc curl ];
in stdenv.mkDerivation rec {
  name = "insomnia-${version}";
  version = "5.14.7";

  src = fetchurl {
    url = "https://github.com/getinsomnia/insomnia/releases/download/v${version}/insomnia_${version}_amd64.deb";
    sha256 = "1y6bn9kaxxplzyv7jjrcsfkrjnivjqdk5mbdp8vz32hv2bmdvzzy";
  };

  nativeBuildInputs = [ makeWrapper dpkg ];

  buildPhase = ":";

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/share/insomnia $out/lib $out/bin

    mv usr/share/* $out/share/
    mv opt/Insomnia/* $out/share/insomnia
    mv $out/share/insomnia/*.so $out/lib/

    ln -s $out/share/insomnia/insomnia $out/bin/insomnia
  '';

  preFixup = ''
    for lib in $out/lib/*.so; do
      patchelf --set-rpath "$out/lib:${libPath}" $lib
    done

    for bin in $out/bin/insomnia; do
      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
               --set-rpath "$out/lib:${libPath}" \
               $bin
    done

    wrapProgram "$out/bin/insomnia" --prefix LD_LIBRARY_PATH : ${runtimeLibs}
  '';

  meta = with stdenv.lib; {
    homepage = https://insomnia.rest/;
    description = "The most intuitive cross-platform REST API Client";
    license = stdenv.lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ markus1189 ];
  };

}
