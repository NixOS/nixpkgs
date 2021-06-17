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
      homepage = "https://tomcat.apache.org/";
      description = "An implementation of the Java Servlet and JavaServer Pages technologies";
      platforms = with lib.platforms; all;
      maintainers = with lib.maintainers; [ danbst ];
      license = [ lib.licenses.asl20 ];
    };
  });

in {
  tomcat7 = common {
    versionMajor = "7";
    versionMinor = "0.100";
    sha256 = "0wjjnvxjz0xbnsfgyp0xc7nlij4z093v54hg59vww2nmkz5mg01v";
  };

  tomcat8 = common {
    versionMajor = "8";
    versionMinor = "5.51";
    sha256 = "1zmg0hi4nw4y5sknd0jgq9lb3bncjjscay5fdiiq3qh5cs0wsvl3";
  };

  tomcat9 = common {
    versionMajor = "9";
    versionMinor = "0.46";
    sha256 = "02p1d7xkmfna5brwi5imjz83g5va1g6fxkiaj4q22l8jpkr6xf6h";
  };
}
