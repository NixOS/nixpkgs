{stdenv, fetchurl, tetex, lazylist}:

assert tetex == lazylist.tetex;

stdenv.mkDerivation {
  name = "polytable-0.8.2";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/polytable-0.8.2.tar.gz;
    md5 = "c59edf035ae6e19b64b1ae920fea28e7";
  };

  propagatedBuildInputs = [tetex lazylist];

  inherit tetex;
}
