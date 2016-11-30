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

  tomcat6 = common {
    versionMajor = "6";
    versionMinor = "0.48";
    sha256 = "1w4jf28g8p25fmijixw6b02iqlagy2rvr57y3n90hvz341kb0bbc";
  };

  tomcat7 = common {
    versionMajor = "7";
    versionMinor = "0.73";
    sha256 = "11gaiy56q7pik06sdypr80sl3g6k41s171wqqwlhxffmsxm4v08f";
  };

  tomcat8 = common {
    versionMajor = "8";
    versionMinor = "0.39";
    sha256 = "16hyypdawby66qa8y66sfprcf78wjy319a0gsi4jgfqfywcsm4s0";
  };

  tomcat85 = common {
    versionMajor = "8";
    versionMinor = "5.5";
    sha256 = "0idfxjrw5q45f531gyjnv6xjkbj9nhy2v1w4z7558z96230a0fqj";
  };

  tomcatUnstable = common {
    versionMajor = "9";
    versionMinor = "0.0.M10";
    sha256 = "0p3pqwz9zjvr9w73divsyaa53mbazf0icxfs06wvgxsvkbgj5gq9";
  };

}
