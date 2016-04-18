{ stdenv, fetchurl, makeWrapper
, dpkg, patchelf
, gtk2, glib, gdk_pixbuf, alsaLib, nss, nspr, GConf, cups, libgcrypt, dbus, libudev }:

let
  inherit (stdenv) lib;
  LD_LIBRARY_PATH = lib.makeLibraryPath
    [ glib gtk2 gdk_pixbuf alsaLib nss nspr GConf cups libgcrypt dbus ];
in
stdenv.mkDerivation rec {
  version = "2.6.0";
  name = "staruml-${version}";

  src =
    if stdenv.system == "i686-linux" then fetchurl {
      url = "http://staruml.io/download/release/v${version}/StarUML-v${version}-32-bit.deb";
      sha256 = "684d7ce7827a98af5bf17bf68d18f934fd970f13a2112a121b1f1f76d6387849";
    } else fetchurl {
      url = "http://staruml.io/download/release/v${version}/StarUML-v${version}-64-bit.deb";
      sha256 = "36e0bdc1bb57b7d808a007a3fafb1b38662d5b0793424d5ad4f51a3a6a9a636d";
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

    ln -s ${stdenv.cc.cc}/lib/libstdc++.so.6 $out/lib/
    ln -s ${libudev.out}/lib/libudev.so.1 $out/lib/libudev.so.0

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
