{stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "re2c-0.13.5";
  src = fetchurl {
    url = mirror://sourceforge/re2c/re2c/0.13.5/re2c-0.13.5.tar.gz;
    sha256 = "1336c54b3cacjxg3grxdraq6a00yidr04z90605fhxglk89rbagk";
  };

  meta = {
    description = "Tool for writing very fast and very flexible scanners";
  };
}
