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

      __structuredAttrs = true;
      strictDeps = true;

      src = fetchurl {
        url = "mirror://apache/tomcat/tomcat-${lib.versions.major version}/v${version}/bin/apache-tomcat-${version}.tar.gz";
        inherit hash;
      };

      outputs = [
        "out"
        "webapps"
      ];

      installPhase = ''
        runHook preInstall

        mkdir $out
        mv * $out
        mkdir -p $webapps/webapps
        mv $out/webapps $webapps/

        runHook postInstall
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
    version = "10.1.57";
    hash = "sha256-vdVK5WniV0FxSlwn7vhfscG4a/K2CDxyq9U/nHhpUIg=";
  };

  tomcat11 = common {
    version = "11.0.24";
    hash = "sha256-EO/tkL8zARSvZieeQ9zyEez897iOYYdXlUrIgylgDLo=";
  };
}
