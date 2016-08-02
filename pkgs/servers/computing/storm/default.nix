{ stdenv, lib, fetchurl, zip, unzip, makeWrapper
, jzmq, jdk, python
, logsDir ? "", confFile ? "", extraLibraryPaths ? [], extraJars ? [] }:

stdenv.mkDerivation rec {
  name = "apache-storm-" + version;
  version = "1.0.1";
  src = fetchurl {
    url =
    "mirror://apache/storm/${name}/${name}.tar.gz";
    sha256 = "1gr00s0fhf8ci0faf3x5dinkiw9mlnc1x1vqki8cfszvij6w0x0m";
  };

  buildInputs = [ zip unzip jzmq ];

  installPhase = ''
    mkdir -p $out/share/${name}
    mv public $out/docs
    mv examples $out/share/${name}/.

    rm -f lib/jzmq* || exit 1
    mv lib $out/.
    mv external extlib* $out/lib/.
    mv conf bin $out/.
    mv log4j2 $out/conf/.
  '';

  fixupPhase = ''
    # Fix python reference
    sed -i \
      -e '19iPYTHON=${python}/bin/python' \
      -e 's|#!/usr/bin/.*python|#!${python}/bin/python|' \
      $out/bin/storm
    sed -i \
      -e 's|#!/usr/bin/.*python|#!${python}/bin/python|' \
      -e "s|STORM_CONF_DIR = .*|STORM_CONF_DIR = os.getenv('STORM_CONF_DIR','$out/conf')|" \
      -e 's|STORM_LOG4J2_CONF_DIR =.*|STORM_LOG4J2_CONF_DIR = os.path.join(STORM_CONF_DIR, "log4j2")|' \
        $out/bin/storm.py
    # Default jdk location
    sed -i -e 's|#.*export JAVA_HOME=.*|export JAVA_HOME="${jdk.home}"|' \
           $out/conf/storm-env.sh
    unzip  $out/lib/storm-core-${version}.jar defaults.yaml;
    zip -d $out/lib/storm-core-${version}.jar defaults.yaml;
    sed -i \
       -e 's|java.library.path: .*|java.library.path: "${jzmq}/lib:${lib.concatStringsSep ":" extraLibraryPaths}"|' \
       -e 's|storm.log4j2.conf.dir: .*|storm.log4j2.conf.dir: "conf/log4j2"|' \
      defaults.yaml
    ${if confFile != "" then ''cat ${confFile} >> defaults.yaml'' else ""}
    mv defaults.yaml $out/conf;

    # Link to jzmq jar and extra jars
    cd $out/lib;
    ln -s ${jzmq}/share/java/*.jar;
    ${lib.concatMapStrings (jar: "ln -s ${jar};\n") extraJars}
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = "http://storm.apache.org";
    description = "Distributed realtime computation system";
    license = licenses.asl20;
    maintainers = with maintainers; [ edwtjo vizanto ];
    platforms = with platforms; unix;
  };
}
