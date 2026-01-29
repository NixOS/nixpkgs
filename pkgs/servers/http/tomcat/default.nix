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
    version = "9.0.113";
    hash = "sha256-eQ2yuAkreVTewq/Gr3Gnu7bGeZgZhRbdap+GVmG10qc=";
  };

  tomcat10 = common {
    version = "10.1.50";
    hash = "sha256-90+fGnrCz27u3ixQ9FCI2cPlX3fVd3+fcDPtPUPvUpw=";
  };

  tomcat11 = common {
    version = "11.0.18";
    hash = "sha256-9P5rc7LkEXinCDMuPeyasq4hNQDBiVdUYRvaKUXbKas=";
  };
}
