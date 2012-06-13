{ fetchurl, stdenv, jdk }:

let

  antContrib = import ./ant-contrib.nix {
    inherit fetchurl stdenv;
  };

  version = "1.8.0RC1";

in

stdenv.mkDerivation {
  name = "ant-${(builtins.parseDrvName jdk.name).name}-${version}";

  builder = ./builder.sh;
  
  buildInputs = [ antContrib jdk ];

  inherit antContrib jdk;

  src = fetchurl {
    url = "http://apache.mirror.transip.nl/ant/binaries/apache-ant-${version}-bin.tar.bz2";
    sha256 = "0xvmrsghibq7p3wvfkmvmkkg0zzfmw32lrfjl5f6cfzchjjnw9wx";
  };
}
