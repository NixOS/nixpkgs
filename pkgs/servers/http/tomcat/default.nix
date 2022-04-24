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
    versionMinor = "0.53";
    sha256 = "1zdnbb0bfbi7762lz69li0wf48jbfz1mv637jzcl42vbsxp4agkv";
  };

  tomcat10 = common {
    versionMajor = "10";
    versionMinor = "0.11";
    sha256 = "1hjvsxxxavni7bis1hm56281ffmf4x0zdh65zqkrnhqa1rbs0lg2";
  };
}
