{ stdenv, fetchurl, unzip, makeWrapper, jre }:

stdenv.mkDerivation {
  name = "ec2-api-tools-1.3-53907";
  
  src = fetchurl {
    url = http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip;
    sha256 = "1jdkc74a9fmjqwvq1pnbsnfqyxxjg5zgaynybmdms5piinvb204d";
  };

  buildInputs = [ unzip makeWrapper ];

  installPhase =
    ''
      ensureDir $out
      mv * $out
      rm $out/bin/*.cmd # Windows stuff

      for i in $out/bin/*; do
          wrapProgram $i \
            --set EC2_HOME $out \
            --set JAVA_HOME ${jre}
      done
    ''; # */
  
  meta = {
    homepage = http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351;
    description = "Command-line tools to create and manage Amazon EC2 virtual machines";
    license = "unfree-redistributable";
  };
}
