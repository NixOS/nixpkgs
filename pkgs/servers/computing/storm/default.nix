{ stdenv, lib, fetchurl, zip, unzip
, jdk, python2
, confFile ? ""
, extraLibraryPaths ? []
, extraJars ? []
}:

stdenv.mkDerivation rec {
  pname = "apache-storm";
  version = "2.3.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://apache/storm/${name}/${name}.tar.gz";
    sha256 = "sha256-ScIlWyZjPG/ZY5nFIDOeRZ/NopoOfm0Mh3XO/P9sNjY=";
  };

  nativeBuildInputs = [ zip unzip ];

  installPhase = ''
    mkdir -p $out/share/${name}
    mv public $out/docs
    mv examples $out/share/${name}/.

    mv external extlib* lib $out/.
    mv conf bin $out/.
    mv log4j2 $out/conf/.
  '';

  fixupPhase = ''
    # Fix python reference
    sed -i \
      -e '19iPYTHON=${python2}/bin/python' \
      -e 's|#!/usr/bin/.*python|#!${python2}/bin/python|' \
      $out/bin/storm
    sed -i \
      -e 's|#!/usr/bin/.*python|#!${python2}/bin/python|' \
      -e "s|STORM_CONF_DIR = .*|STORM_CONF_DIR = os.getenv('STORM_CONF_DIR','$out/conf')|" \
      -e 's|STORM_LOG4J2_CONF_DIR =.*|STORM_LOG4J2_CONF_DIR = os.path.join(STORM_CONF_DIR, "log4j2")|' \
        $out/bin/storm.py

    # Default jdk location
    sed -i -e 's|#.*export JAVA_HOME=.*|export JAVA_HOME="${jdk.home}"|' \
           $out/conf/storm-env.sh
    ls -lh $out/lib
    unzip  $out/lib/storm-client-${version}.jar defaults.yaml;
    zip -d $out/lib/storm-client-${version}.jar defaults.yaml;
    sed -i \
       -e 's|java.library.path: .*|java.library.path: "${lib.concatStringsSep ":" extraLibraryPaths}"|' \
       -e 's|storm.log4j2.conf.dir: .*|storm.log4j2.conf.dir: "conf/log4j2"|' \
      defaults.yaml
    ${if confFile != "" then "cat ${confFile} >> defaults.yaml" else ""}
    mv defaults.yaml $out/conf;

    # Link to extra jars
    cd $out/lib;
    ${lib.concatMapStrings (jar: "ln -s ${jar};\n") extraJars}
  '';

  dontStrip = true;

  meta = with lib; {
    homepage = "https://storm.apache.org/";
    description = "Distributed realtime computation system";
    license = licenses.asl20;
    maintainers = with maintainers; [ edwtjo vizanto ];
    platforms = with platforms; unix;
  };
}
