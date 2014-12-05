{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "re2c-${version}";
  version = "0.13.7.5";

  src = fetchurl {
    url    = "mirror://sourceforge/re2c/re2c/${version}/${name}.tar.gz";
    sha256 = "0qdly4493d4p6jif0anf79c8h6ylc34aw622zk4n8icyax8gv2nm";
  };

  meta = {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "http://re2c.org";
    license     = stdenv.lib.licenses.publicDomain;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
