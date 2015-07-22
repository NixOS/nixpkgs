{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "re2c-${version}";
  version = "0.14.3";

  src = fetchurl {
    url    = "mirror://sourceforge/re2c/re2c/${version}/${name}.tar.gz";
    sha256 = "113yj5h38isfsjigqvb2j3ammfmxckgwyxmm0h4fyflzb7ghcs0w";
  };

  meta = {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "http://re2c.org";
    license     = stdenv.lib.licenses.publicDomain;
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
