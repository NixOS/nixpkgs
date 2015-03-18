{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "re2c-${version}";
  version = "0.14.1";

  src = fetchurl {
    url    = "mirror://sourceforge/re2c/re2c/${version}/${name}.tar.gz";
    sha256 = "0xfskwzr6n94sa22m24x7z051qfbb9d6k4dipcv95s8j8zq74dcv";
  };

  meta = {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "http://re2c.org";
    license     = stdenv.lib.licenses.publicDomain;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
