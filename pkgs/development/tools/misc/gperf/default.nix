{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gperf-3.0.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gperf-3.0.2.tar.gz;
    md5 = "5359fae9929f9f7235c6601f4b6e8c89";
  };
}
