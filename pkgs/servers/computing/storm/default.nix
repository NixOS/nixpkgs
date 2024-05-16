{ stdenv, lib, fetchurl, zip, unzip
, jdk, python3
, confFile ? ""
, extraLibraryPaths ? []
, extraJars ? []
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apache-storm";
  version = "2.6.2";
  name = "${finalAttrs.pname}-${finalAttrs.version}";

  src = fetchurl {
    url = "mirror://apache/storm/${finalAttrs.name}/${finalAttrs.name}.tar.gz";
    hash = "sha256-ZAwsVKWTzc/++UQTNnOHdK5hiDDT5j6453DCLWi+7TA=";
  };

  nativeBuildInputs = [ zip unzip ];

  installPhase = ''
    mkdir -p $out/share/${finalAttrs.name}
    mv public $out/docs
    mv examples $out/share/${finalAttrs.name}/.

    mv external extlib* lib $out/.
    mv conf bin $out/.
    mv log4j2 $out/conf/.
  '';

  fixupPhase = ''
    patchShebangs $out
    # Fix python reference
    sed -i \
      -e '19iPYTHON=${python3}/bin/python' \
      -e 's|#!/usr/bin/.*python|#!${python3}/bin/python|' \
      $out/bin/storm
    sed -i \
      -e 's|#!/usr/bin/.*python|#!${python3}/bin/python|' \
      -e "s|STORM_CONF_DIR = .*|STORM_CONF_DIR = os.getenv('STORM_CONF_DIR','$out/conf')|" \
      -e 's|STORM_LOG4J2_CONF_DIR =.*|STORM_LOG4J2_CONF_DIR = os.path.join(STORM_CONF_DIR, "log4j2")|' \
        $out/bin/storm.py

    # Default jdk location
    sed -i -e 's|export JAVA_HOME=.*|export JAVA_HOME="${jdk.home}"|' \
           $out/conf/storm-env.sh
    unzip  $out/lib/storm-client-${finalAttrs.version}.jar defaults.yaml;
    zip -d $out/lib/storm-client-${finalAttrs.version}.jar defaults.yaml;
    sed -i \
       -e 's|java.library.path: .*|java.library.path: "${lib.concatStringsSep ":" extraLibraryPaths}"|' \
       -e 's|storm.log4j2.conf.dir: .*|storm.log4j2.conf.dir: "conf/log4j2"|' \
      defaults.yaml
    ${lib.optionalString (confFile != "") "cat ${confFile} >> defaults.yaml"}
    mv defaults.yaml $out/conf;

    # Link to extra jars
    cd $out/lib;
    ${lib.concatMapStrings (jar: "ln -s ${jar};\n") extraJars}
  '';

  dontStrip = true;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "storm version";
  };

  meta = with lib; {
    homepage = "https://storm.apache.org/";
    description = "Distributed realtime computation system";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ edwtjo vizanto ];
    platforms = with platforms; unix;
  };
})
