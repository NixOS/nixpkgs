{stdenv, fetchurl, neon}:

stdenv.mkDerivation {
  name = "sitecopy-0.16.6";

  src = fetchurl {
    url = http://www.manyfish.co.uk/sitecopy/sitecopy-0.16.6.tar.gz;
    sha256 = "1bsqfhfq83g1qambqf8i1ivvggz5d2byg94hmrpxqkg50yhdsvz0";
  };

}
