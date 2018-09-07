{ stdenv, lib, makeWrapper, fetchurl, dpkg
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype
, gdk_pixbuf, glib, gnome2, gtk2-x11, nspr, nss
, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext
, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb, nghttp2
, libudev0-shim, glibc, curl, openssl
}:

let
  libPath = lib.makeLibraryPath [
    alsaLib atk cairo cups dbus expat fontconfig freetype gdk_pixbuf glib gnome2.GConf gnome2.pango
    gtk2-x11 nspr nss stdenv.cc.cc libX11 libXScrnSaver libXcomposite libXcursor libXdamage libXext libXfixes
    libXi libXrandr libXrender libXtst libxcb
  ];
  runtimeLibs = lib.makeLibraryPath [ libudev0-shim glibc curl openssl nghttp2 ];
in stdenv.mkDerivation rec {
  name = "insomnia-${version}";
  version = "6.0.2";

  src = fetchurl {
    url = "https://github.com/getinsomnia/insomnia/releases/download/v${version}/insomnia_${version}_amd64.deb";
    sha256 = "18xspbaal945bmrwjnsz1sjba53040wxrzvig40nnclwj8h671ms";
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
