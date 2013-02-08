{ stdenv, fetchurl, unzip, jzmq, jdk, lib, python, logsDir, confDir }:

stdenv.mkDerivation {
  name = "storm-0.8.2";
  src = fetchurl {
    url = https://dl.dropbox.com/u/133901206/storm-0.8.2.zip;
    sha256 = "8761aea0b54e5bab4a68b259bbe6b5b2f8226204488b5559eba57a0c458b2bbc";
  };

  buildInputs = [ unzip jzmq ];

  installPhase = ''
    # Remove junk
    rm -f lib/jzmq*
    mkdir -p $out/bin
    mv bin/storm $out/bin/
    rm -R bin conf logs

    # Fix shebang header for python scripts
    sed -i -e "s|#!/usr/bin/.*python|#!${python}/bin/python|" $out/bin/storm;

    mkdir -p $out
    cp -av * $out
    cd $out;
    ${if logsDir != "" then ''ln -s ${logsDir} logs'' else ""}
    ${if confDir != "" then ''ln -s ${confDir} conf'' else ""}
  '';

  dontStrip = true;

  meta = {
    homepage = "http://storm-project.net";
    description = "Storm, free and open source distributed realtime computation system.";
    license = "Eclipse Public License 1.0";
    maintainers = [ lib.maintainers.blue ];
  };
}
