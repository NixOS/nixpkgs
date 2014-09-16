{ fetchurl, pkgs, stdenv, qt5, yajl, libzip, hunspell, lua5_1, boost }:

stdenv.mkDerivation rec {
  name = "mudlet-${version}";
  version = "3.1";

  src = fetchurl {
    url = "https://github.com/Mudlet/Mudlet/archive/release_31.zip";
    sha256 = "43cb70e5e559cb265440cd0e68e659ab102a3ebf98b9eb2061b6685e04a6449c";
  };

  buildInputs = [ pkgs.unzip qt5 lua5_1 hunspell libzip yajl boost ];

  configurePhase = "cd src && qmake";

  installPhase = ''
    mkdir -pv $out
    mkdir -pv $out/bin
    cp mudlet $out
    cp -r mudlet-lua $out
    ln -s $out/mudlet $out/bin/mudlet
  '';

  patches = [ ./libs.patch ];

  meta = {
    description = "Crossplatform mud client";
    homepage = http://mudlet.org/;
    maintainers = [ stdenv.lib.maintainers.wyvie ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.free;
  };
}
