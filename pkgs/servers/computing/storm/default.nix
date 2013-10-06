{ stdenv, fetchurl, zip, unzip, jzmq, jdk, lib, python, logsDir ? "", confFile ? "", extraLibraryPaths ? [], extraJars ? [] }:

stdenv.mkDerivation {
  name = "storm-0.8.2";
  src = fetchurl {
    url = https://dl.dropbox.com/u/133901206/storm-0.8.2.zip;
    sha256 = "8761aea0b54e5bab4a68b259bbe6b5b2f8226204488b5559eba57a0c458b2bbc";
  };

  buildInputs = [ zip unzip jzmq ];

  installPhase = ''
    # Remove junk
    rm -f lib/jzmq*
    mkdir -p $out/bin
    mv bin/storm $out/bin/
    rm -R bin conf logs

    # Fix shebang header for python scripts
    sed -i -e "s|#!/usr/bin/.*python|#!${python}/bin/python|" $out/bin/storm;

    mkdir -p $out/conf
    cp -av * $out

    cd $out;
    ${if logsDir  != "" then ''ln -s ${logsDir} logs'' else ""}

    # Extract, delete from zip; and optionally append to defaults.yaml
    unzip  storm-*.jar defaults.yaml;
    zip -d storm-*.jar defaults.yaml;
    echo 'java.library.path: "${jzmq}/lib:${lib.concatStringsSep ":" extraLibraryPaths}"' >> defaults.yaml;
    ${if confFile != "" then ''cat ${confFile} >> defaults.yaml'' else ""}
    mv defaults.yaml conf;

    # Link to jzmq jar and extra jars
    cd lib;
    ln -s ${jzmq}/share/java/*.jar;
    ${lib.concatMapStrings (jar: "ln -s ${jar};\n") extraJars}
  '';

  dontStrip = true;

  meta = {
    homepage = "http://storm-project.net";
    description = "Distributed realtime computation system";
    license = "Eclipse Public License 1.0";
    maintainers = [ lib.maintainers.vizanto ];
  };
}
