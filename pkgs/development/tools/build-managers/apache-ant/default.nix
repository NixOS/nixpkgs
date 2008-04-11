{fetchurl, stdenv, jdk, name}:

let {
  body =
    stdenv.mkDerivation {
      name = name;

      builder = ./builder.sh;
      buildInputs = [antContrib jdk];

      inherit antContrib jdk;

      src = fetchurl {
        url = http://apache.surfnet.nl/ant/binaries/apache-ant-1.6.5-bin.tar.bz2;
        md5 = "26031ee1a2fd248ad0cc2e7f17c44c39";
      };
    };

  antContrib =
    (import ./ant-contrib.nix) {
      inherit fetchurl stdenv;
    };
}
