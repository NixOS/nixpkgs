# Note: sdf2-bundle currently requires GNU make 3.80; remove explicit
# dependency when this is fixed.
{stdenv, fetchurl, aterm, getopt, pkgconfig, make}:

stdenv.mkDerivation {
  name = "sdf2-bundle-2.3.3";
  src = fetchurl {
    url = ftp://ftp.stratego-language.org/pub/stratego/sdf2/sdf2-bundle-2.3.3/sdf2-bundle-2.3.3.tar.gz;
    md5 = "62ecabe5fbb8bbe043ee18470107ef88";
  };

  buildInputs = [aterm pkgconfig make];
  propagatedBuildInputs = [getopt];
}
