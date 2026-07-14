{
  fetchurl,
  gitUpdater,
  jre,
  lib,
  nixosTests,
  stdenvNoCC,
  testers,
}:

let
  common =
    { version, hash }:
    stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "apache-tomcat";
      inherit version;

      src = fetchurl {
        url = "mirror://apache/tomcat/tomcat-${lib.versions.major version}/v${version}/bin/apache-tomcat-${version}.tar.gz";
        inherit hash;
      };

      outputs = [
        "out"
        "webapps"
      ];

      installPhase = ''
        mkdir $out
        mv * $out
        mkdir -p $webapps/webapps
        mv $out/webapps $webapps/
      '';

      passthru = {
        updateScript = gitUpdater {
          url = "https://github.com/apache/tomcat.git";
          allowedVersions = "^${lib.versions.major version}\\.";
          ignoredVersions = "-M.*";
        };
        tests = {
          inherit (nixosTests) tomcat;
          version = testers.testVersion {
            package = finalAttrs.finalPackage;
            command = "JAVA_HOME=${jre} ${finalAttrs.finalPackage}/bin/version.sh";
          };
        };
      };

      meta = {
        homepage = "https://tomcat.apache.org/";
        description = "Implementation of the Java Servlet and JavaServer Pages technologies";
        platforms = jre.meta.platforms;
        maintainers = with lib.maintainers; [ anthonyroussel ];
        license = lib.licenses.asl20;
        sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
      };
    });

in
{
  tomcat9 = common {
    version = "9.0.120";
    hash = "sha256-HevX6bz17tjIpyccn6r2mfSUGoOZLaxa2BSg52fOXiY=";
  };

  tomcat10 = common {
    version = "10.1.55";
    hash = "sha256-l4oNCJA0XuxSo4yWcKjhEtTMjPjLEO9B0F1rcXiFdJU=";
  };

  tomcat11 = common {
    version = "11.0.24";
    hash = "sha256-EO/tkL8zARSvZieeQ9zyEez897iOYYdXlUrIgylgDLo=";
  };
}
