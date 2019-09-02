{ stdenv, lib, fetchurl }:

let

  common = { versionMajor, versionMinor, sha256 }: stdenv.mkDerivation (rec {
    pname = "apache-tomcat";
    version = "${versionMajor}.${versionMinor}";

    src = fetchurl {
      url = "mirror://apache/tomcat/tomcat-${versionMajor}/v${version}/bin/${pname}-${version}.tar.gz";
      inherit sha256;
    };

    outputs = [ "out" "webapps" ];
    installPhase =
      ''
        mkdir $out
        mv * $out
        mkdir -p $webapps/webapps
        mv $out/webapps $webapps/
      '';

    meta = {
      homepage = https://tomcat.apache.org/;
      description = "An implementation of the Java Servlet and JavaServer Pages technologies";
      platforms = with lib.platforms; all;
      maintainers = with lib.maintainers; [ danbst ];
      license = [ lib.licenses.asl20 ];
    };
  });

in {
  tomcat7 = common {
    versionMajor = "7";
    versionMinor = "0.92";
    sha256 = "0j015mf15drl92kvgyi1ppzjziw0k1rwvfnih8r20h92ylk8mznk";
  };

  tomcat8 = common {
    versionMajor = "8";
    versionMinor = "0.53";
    sha256 = "1ymp5n6xjqzpqjjlwql195v8r5fsmry7nfax46bafkjw8b24g80r";
  };

  tomcat85 = common {
    versionMajor = "8";
    versionMinor = "5.42";
    sha256 = "1d90abwwvl0ghr0g0drk48j37wr2zgw74vws9z2rshyzrwgbvgp3";
  };

  tomcat9 = common {
    versionMajor = "9";
    versionMinor = "0.21";
    sha256 = "0nsylbqvky4pf3wpsx3a29b85lvwk91ay37mljk9636qffjj1vjh";
  };
}
