{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "rng-tools-4";

  src = fetchurl {
    url = "mirror://sourceforge/gkernel/${name}.tar.gz";

    sha256 = "15f17j3lxn1v2mhdxvy3pahz41hn1vlnnm81c0qyh19c4bady6xp";
  };

  meta = {
    description = "A random number generator daemon";

    homepage = http://sourceforge.net/projects/gkernel;

    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux;

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
