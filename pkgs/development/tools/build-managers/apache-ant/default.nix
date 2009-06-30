{fetchurl, stdenv, jdk, name}:

let {
  body =
    stdenv.mkDerivation {
      name = name;

      builder = ./builder.sh;
      buildInputs = [antContrib jdk];

      inherit antContrib jdk;

      src = fetchurl {
        url = http://apache.mirror.transip.nl/ant/binaries/apache-ant-1.7.1-bin.tar.bz2 ;
        sha256 = "15rgkini0g100jygp7z9hgc3yfb9m62q4nk989rin7dqj2flrr94";
      };
    };

  antContrib =
    (import ./ant-contrib.nix) {
      inherit fetchurl stdenv;
    };
}
