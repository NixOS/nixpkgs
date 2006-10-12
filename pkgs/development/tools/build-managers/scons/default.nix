{stdenv, fetchurl, python}:

stdenv.mkDerivation {
  name = "scons-0.96.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/scons-0.96.1.tar.gz;
    md5 = "45b1c346edd8a0970210aeb1e82557c9";
  };
  buildInputs = [python];
}
