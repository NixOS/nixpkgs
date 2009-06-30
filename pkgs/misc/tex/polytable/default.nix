{stdenv, fetchurl, tetex, lazylist}:

#assert tetex == lazylist.tetex;

stdenv.mkDerivation {
  name = "polytable-0.8.2";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.iai.uni-bonn.de/~loeh/polytable-0.8.2.tar.gz;
    md5 = "c59edf035ae6e19b64b1ae920fea28e7";
  };

  buildInputs = [tetex];
  propagatedBuildInputs = [lazylist];
  propagatedUserEnvPackages = [lazylist];

  inherit tetex;
}
