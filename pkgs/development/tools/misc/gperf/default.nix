{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gperf-2.7.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/gperf-2.7.2.tar.gz;
    md5 = "e501acc2e18eed2c8f25ca0ac2330d68";
  };
}
