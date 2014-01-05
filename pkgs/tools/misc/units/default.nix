{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "units-2.02";

  src = fetchurl {
    url = mirror://gnu/units/units-2.02.tar.gz;
    sha256 = "16jfji9g1zc99agd5dcinajinhcxr4dgq2lrbc9md69ir5qgld1b";
  };

  meta = {
    description = "Unit conversion tool";
  };
}
