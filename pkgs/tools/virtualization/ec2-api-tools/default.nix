{ stdenv, fetchurl, unzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "ec2-api-tools-1.7.5.1";

  src = fetchurl {
    url = "http://tarballs.nixos.org/${name}.zip";
    sha256 = "0figmvcm82ghmpz3018ihysz8zpxpysgbpdx7rmciq9y80qbw6l5";
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase =
    ''
      d=$out/libexec/ec2-api-tools
      mkdir -p $d
      mv * $d
      rm $d/bin/*.cmd # Windows stuff

      for i in $d/bin/*; do
          b=$(basename $i)
          if [ $b = "ec2-cmd" ]; then continue; fi
          makeWrapper $i $out/bin/$(basename $i) \
            --set EC2_HOME $d \
            --set JAVA_HOME ${jre}
      done
    ''; # */

  meta = {
    homepage = http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351;
    description = "Command-line tools to create and manage Amazon EC2 virtual machines";
    license = stdenv.lib.licenses.amazonsl;
  };
}
