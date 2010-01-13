{fetchurl, stdenv, jdk, name}:

let {
  body =
    stdenv.mkDerivation {
      name = name;

      builder = ./builder.sh;
      buildInputs = [antContrib jdk];

      inherit antContrib jdk;

      src = fetchurl {
        url = http://apache.mirror.transip.nl/ant/binaries/apache-ant-1.8.0RC1-bin.tar.bz2 ;
        sha256 = "0xvmrsghibq7p3wvfkmvmkkg0zzfmw32lrfjl5f6cfzchjjnw9wx";
      };
    };

  antContrib =
    (import ./ant-contrib.nix) {
      inherit fetchurl stdenv;
    };
}
