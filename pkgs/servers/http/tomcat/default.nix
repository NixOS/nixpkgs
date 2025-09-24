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
    version = "9.0.108";
    hash = "sha256-qpEnzHOPUyqjTjR7MGqCFX+1tJm/wCi0/69521lW0o0=";
  };

  tomcat10 = common {
    version = "10.1.44";
    hash = "sha256-4CDC+oZJ8d6au8LdznDdYemX0O0WHuAqMN5LIhJjvpw=";
  };

  tomcat11 = common {
    version = "11.0.11";
    hash = "sha256-KpG4DB6n279K8Fux+Aq7l15d5BXAyAPep0XlqhEm4IE=";
  };
}
