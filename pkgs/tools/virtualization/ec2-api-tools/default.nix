{ stdenv, fetchurl, unzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "ec2-api-tools-1.6.5.1";

  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.zip";
    sha256 = "1j2pc20vggi4hv950999mhh7dl6475yma76nyj6k0hzkd1lf5hda";
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
    license = "unfree-redistributable";
  };
}
