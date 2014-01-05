{stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "re2c-0.13.6";
  src = fetchurl {
    url = mirror://sourceforge/re2c/re2c/0.13.6/re2c-0.13.6.tar.gz;
    sha256 = "1h3na1zacw3166k6wkdjzjs67frjca9wj07wgfas56c7m8wk0ilf";
  };

  meta = {
    description = "Tool for writing very fast and very flexible scanners";
  };
}
