{ stdenv, fetchurl, makeWrapper
, dpkg, patchelf
, gtk2, glib, gdk_pixbuf, alsaLib, nss, nspr, GConf, cups, libgcrypt, dbus, systemd }:

let
  inherit (stdenv) lib;
  LD_LIBRARY_PATH = lib.makeLibraryPath
    [ glib gtk2 gdk_pixbuf alsaLib nss nspr GConf cups libgcrypt dbus ];
in
stdenv.mkDerivation rec {
  version = "2.8.1";
  name = "staruml-${version}";

  src =
    if stdenv.system == "i686-linux" then fetchurl {
      url = "http://staruml.io/download/release/v${version}/StarUML-v${version}-32-bit.deb";
      sha256 = "0vb3k9m3l6pmsid4shlk0xdjsriq3gxzm8q7l04didsppg0vvq1n";
    } else fetchurl {
      url = "http://staruml.io/download/release/v${version}/StarUML-v${version}-64-bit.deb";
      sha256 = "05gzrnlssjkhyh0wv019d4r7p40lxnsa1sghazll6f233yrqmxb0";
    };

  buildInputs = [ dpkg ];

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';

  installPhase = ''
    mkdir $out
    mv opt/staruml $out/bin

    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/StarUML

    mkdir -p $out/lib

    ln -s ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 $out/lib/
    ln -s ${systemd.lib}/lib/libudev.so.1 $out/lib/libudev.so.0

    wrapProgram $out/bin/StarUML \
      --prefix LD_LIBRARY_PATH : $out/lib:${LD_LIBRARY_PATH}
  '';

  meta = with stdenv.lib; {
    description = "A sophisticated software modeler";
    homepage = http://staruml.io/;
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
