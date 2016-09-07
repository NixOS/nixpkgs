{ stdenv, fetchurl }:

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
      homepage = http://tomcat.apache.org/;
      description = "An implementation of the Java Servlet and JavaServer Pages technologies";
      platforms = with stdenv.lib.platforms; all;
    };
  });

in {

  tomcat6 = common {
    versionMajor = "6";
    versionMinor = "0.45";
    sha256 = "0ba8h86padpk23xmscp7sg70g0v8ji2jbwwriz59hxqy5zhd76wg";
  };

  tomcat7 = common {
    versionMajor = "7";
    versionMinor = "0.68";
    sha256 = "1q5qgci5ia25zqa1k1n2xzarsgk1317ya89mfgg0fmi65x1046ic";
  };

  tomcat8 = common {
    versionMajor = "8";
    versionMinor = "0.32";
    sha256 = "1f59x5z8qf4rzy49m8d5ifi4h1ghkz5r33l3i67sib414h7jc8vy";
  };

}
