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
    versionMinor = "0.46";
    sha256 = "02p1d7xkmfna5brwi5imjz83g5va1g6fxkiaj4q22l8jpkr6xf6h";
  };

  tomcat10 = common {
    versionMajor = "10";
    versionMinor = "0.6";
    sha256 = "1bpcxpsfws3b8ykq53vrcx3f04mvs5if80p329jm3x2dvdvj3d9n";
  };
}
