{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "units-2.11";

  src = fetchurl {
    url = mirror://gnu/units/units-2.11.tar.gz;
    sha256 = "1gjs3wc212aaiq4r76hx9nl1h3fa39n0ljwl9420d6ixl3rdmdjk";
  };

  meta = {
    description = "Unit conversion tool";
    platforms = stdenv.lib.platforms.linux;
  };
}
