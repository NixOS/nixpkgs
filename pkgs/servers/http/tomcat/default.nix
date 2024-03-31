{ stdenv, lib, fetchurl, nixosTests, testers, jre }:

let
  common = { version, hash }: stdenv.mkDerivation (finalAttrs: {
    pname = "apache-tomcat";
    inherit version;

    src = fetchurl {
      url = "mirror://apache/tomcat/tomcat-${lib.versions.major version}/v${version}/bin/apache-tomcat-${version}.tar.gz";
      inherit hash;
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
      platforms = jre.meta.platforms;
      maintainers = with maintainers; [ anthonyroussel ];
      license = [ licenses.asl20 ];
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
    };
  });

in {
  tomcat9 = common {
    version = "9.0.87";
    hash = "sha256-2kgvuSIAhtvzceGAqgnGQCr48EhYZzTN7dSgjEjUzgI=";
  };

  tomcat10 = common {
    version = "10.1.20";
    hash = "sha256-hCfFUJ8U5IKUCgFfP2DeIDQtPXLI3qmYKk1xEstxpu4=";
  };
}
