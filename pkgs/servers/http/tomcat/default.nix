{ stdenv, lib, fetchurl }:

let

  common = { versionMajor, versionMinor, sha256 } @ args: stdenv.mkDerivation (rec {
    name = "apache-tomcat-${version}";
    version = "${versionMajor}.${versionMinor}";

    src = fetchurl {
      url = "mirror://apache/tomcat/tomcat-${versionMajor}/v${version}/bin/${name}.tar.gz";
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
    versionMinor = "0.81";
    sha256 = "0mcr3caizqk6qrc0j9p91apdsg65ksawg0l6xpqk1fq6071nd5rq";
  };

  tomcat8 = common {
    versionMajor = "8";
    versionMinor = "0.46";
    sha256 = "14wb9mgb7z02j6wvvmcsfc2zkcqnijc40gzyg1mnxcy5fvf8nzpk";
  };

  tomcat85 = common {
    versionMajor = "8";
    versionMinor = "5.20";
    sha256 = "1l5cgxzaassjnfbr4rbr3wzz45idcqa8aqhphhvlx1xl8xqv6p8a";
  };

  tomcatUnstable = common {
    versionMajor = "9";
    versionMinor = "0.0.M17";
    sha256 = "1ilvka2062m7412bj2fsdwvfxbrjyj9qxcia40hhv22prvkxw3cg";
  };
}
