{ fetchurl, stdenv, jdk }:

let

  antContrib = import ./ant-contrib.nix {
    inherit fetchurl stdenv;
  };

  version = "1.8.4";

in

stdenv.mkDerivation {
  name = "ant-${(builtins.parseDrvName jdk.name).name}-${version}";

  builder = ./builder.sh;
  
  buildInputs = [ antContrib jdk ];

  inherit antContrib jdk;

  src = fetchurl {
    url = "mirror://apache/ant/binaries/apache-ant-${version}-bin.tar.bz2";
    sha1 = "d9e3e83dd9664cfe1dcd4841c082db3f559af922";
  };

  meta = {
    description = "Java-based build tool";
  };
}
