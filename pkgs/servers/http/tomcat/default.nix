{ stdenv, lib, fetchurl, nixosTests, testers, jre }:

let

  common = { versionMajor, versionMinor, sha256 }: stdenv.mkDerivation (finalAttrs: {
    pname = "apache-tomcat";
    version = "${versionMajor}.${versionMinor}";

    src = fetchurl {
      url = "mirror://apache/tomcat/tomcat-${versionMajor}/v${finalAttrs.version}/bin/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
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

    passthru.tests = {
      inherit (nixosTests) tomcat;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "JAVA_HOME=${jre} ${finalAttrs.finalPackage}/bin/version.sh";
      };
    };

    meta = with lib; {
      homepage = "https://tomcat.apache.org/";
      description = "An implementation of the Java Servlet and JavaServer Pages technologies";
      platforms = platforms.all;
      maintainers = with maintainers; [ anthonyroussel ];
      license = [ licenses.asl20 ];
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
    };
  });

in {
  tomcat9 = common {
    versionMajor = "9";
    versionMinor = "0.83";
    sha256 = "sha256-dgktroncHzrm3RFATWSFJ2GkAfGM03PJO1/37yzk+Qo=";
  };

  tomcat10 = common {
    versionMajor = "10";
    versionMinor = "1.15";
    sha256 = "sha256-cqQW3Dc3sC/1zoidMIGDBNw4G5bnxYvhmHz7U7K6Djg=";
  };
}
