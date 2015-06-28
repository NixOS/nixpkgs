{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "re2c-${version}";
  version = "0.14.2";

  src = fetchurl {
    url    = "mirror://sourceforge/re2c/re2c/${version}/${name}.tar.gz";
    sha256 = "0c0w5w1dp9v9d0a6smjbnk6zvfs77fx1xd7damap3x3sjxiyn0m7";
  };

  meta = {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "http://re2c.org";
    license     = stdenv.lib.licenses.publicDomain;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
