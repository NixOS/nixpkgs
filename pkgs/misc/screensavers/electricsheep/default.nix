{stdenv, fetchurl, pkgconfig, expat, zlib, libpng, libjpeg, xlibs}:

stdenv.mkDerivation rec {
  name = "electricsheep-2.6.8";
  
  src = fetchurl {
    url = "http://electricsheep.org/${name}.tar.gz";
    sha256 = "1flqcqfs75wg74hr5w85n6w8b26l4qrpwzi7fzylnry67yzf94y5";
  };

  buildInputs = [pkgconfig expat zlib libpng libjpeg xlibs.xlibs xlibs.libXv];

  preInstall = ''
    installFlags=GNOME_DATADIR=$out
    mkdir -p $out/control-center/screensavers
  '';

  meta = {
    description = "Electric Sheep, a distributed screen saver for evolving artificial organisms";
    homepage = http://electricsheep.org/;
  };
}
