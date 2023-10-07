{ lib
, stdenv
, fetchurl
, unzip
, makeWrapper
, jre
}:

stdenv.mkDerivation rec {
  pname = "ec2-api-tools";
  version = "1.7.5.1";

  src = fetchurl {
    url = "http://s3.amazonaws.com/ec2-downloads/${pname}-${version}.zip";
    sha256 = "sha256-hRq+MEA+4chqPr3d9bS//X70tYcRBTD+rfAJVNmuLzo=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  installPhase = ''
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
  '';

  meta = {
    homepage = "http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351";
    description = "Command-line tools to create and manage Amazon EC2 virtual machines";
    license = lib.licenses.amazonsl;
  };
}
