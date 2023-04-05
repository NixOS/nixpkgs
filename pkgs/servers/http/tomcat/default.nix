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

    meta = with lib; {
      homepage = "https://tomcat.apache.org/";
      description = "An implementation of the Java Servlet and JavaServer Pages technologies";
      platforms = platforms.all;
      maintainers = [ ];
      license = [ licenses.asl20 ];
    };
  });

in {
  tomcat9 = common {
    versionMajor = "9";
    versionMinor = "0.68";
    sha256 = "sha256-rxsv8zEIIbTel4CqIuncS5pellGwgHamKRa0KgzsOF0=";
  };

  tomcat10 = common {
    versionMajor = "10";
    versionMinor = "0.27";
    sha256 = "sha256-N2atmOdhVrGx88eXOc9Wziq8kn7IWzTeFyFpir/5HLc=";
  };
}
