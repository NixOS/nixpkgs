{stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "re2c-${version}";
  version = "0.13.7.4";

  src = fetchurl {
    url    = "mirror://sourceforge/re2c/re2c/${version}/${name}.tar.gz";
    sha256 = "0j42s2gpz0rgiadwyb7ksqgc7i02l0q2qnmiyaj5f1w5rfa2c7yy";
  };

  meta = {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "http://re2c.org";
    license     = stdenv.lib.license.publicDomain;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
