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
    versionMinor = "5.8";
    sha256 = "1rfws897m09pbnb1jc4684didpklfhqp86szv2jcqzdx0hlfxxs0";
  };

  tomcatUnstable = common {
    versionMajor = "9";
    versionMinor = "0.0.M13";
    sha256 = "0im3w4iqpar7x50vg7c9zkxyqf9x53xs5jvcq79xqgrmcqb9lk91";
  };

}
