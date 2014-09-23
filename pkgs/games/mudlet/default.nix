{ fetchurl, pkgs, stdenv, makeWrapper, qt5, yajl, libzip, hunspell, lua5_1, boost, filesystem }:

stdenv.mkDerivation rec {
  name = "mudlet-${version}";
  version = "3.0";

  src = fetchurl {
    url = "https://github.com/Mudlet/Mudlet/archive/6bc55dde0499cffab48b0021f27dcff1d57b0b66.zip";
    sha256 = "c7b9a383d2cf393da730ce07ac8f06478eaec1fdf730054e837e58c598222d38";
  };

  buildInputs = [ pkgs.unzip qt5 lua5_1 hunspell libzip yajl boost makeWrapper filesystem ];

  configurePhase = "cd src && qmake";

  installPhase = ''
    mkdir -pv $out
    mkdir -pv $out/bin
    cp mudlet $out
    cp -r mudlet-lua $out

    # ln -s $out/mudlet $out/bin/mudlet
    makeWrapper $out/mudlet $out/bin/mudlet \
      --set LUA_CPATH "${filesystem}/lib/lua/5.1/?.so"
  '';

  patches = [ ./libs.patch ];

  meta = {
    description = "Crossplatform mud client";
    homepage = http://mudlet.org/;
    maintainers = [ stdenv.lib.maintainers.wyvie ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
