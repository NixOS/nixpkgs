{stdenv, fetchurl, makeWrapper, openjdk, rlwrap, clojure }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.0.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "0malymlswxwgh8amkw37qjb8n34ylw3chgbdxgxkq34rkvhv60hb";
  };

  jarsrc = fetchurl {
    url = "https://leiningen.s3.amazonaws.com/downloads/leiningen-2.0.0-standalone.jar";
    sha256 = "10jvk19mr5dcl5a9kzna9zslh77v3ixi8awhrhxi30dn1yj3r7ck";
  };

  patches = ./lein_2.0.0.patch;

  inherit rlwrap clojure;

  builder = ./builder.sh;

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ openjdk clojure ];

  meta = {
    homepage = https://github.com/technomancy/leiningen;
    description = "Project automation for Clojure";
    license = "EPL";
    platforms = stdenv.lib.platforms.unix;
  };
}
