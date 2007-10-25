{stdenv, fetchurl, pkgconfig, glib, fuse, perl}:

stdenv.mkDerivation {
  name = "fuseftp-0.8";
  src = fetchurl {
    url = http://perl.thiesen.org/fuseftp/fuseftp-0.8.tar.gz;
    sha256 = "7abc552eead7934fe1cb7c8cde3b83dd9d01c4a812db1a7d9ab8d9e0860923dc";
  };
  buildInputs = [pkgconfig glib fuse perl];

  builder = ./builder.sh;

  inherit perl;
}
