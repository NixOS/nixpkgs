{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "oidentd-${version}";
  version = "2.2.2";

  CFLAGS = [ "--std=gnu89" ];

  src = fetchurl {
    url = "https://ftp.janikrabe.com/pub/oidentd/releases/${version}/${name}.tar.gz";
    sha256 = "1svj7ymljp4s17d7jlx6602n9081714qsj5yymmv1s9wagzjqyn9";
  };

  meta = {
    homepage = http://ojnk.sourceforge.net/;
    description = "An implementation of the IDENT protocol";
    platforms = stdenv.lib.platforms.linux;
  };
}
