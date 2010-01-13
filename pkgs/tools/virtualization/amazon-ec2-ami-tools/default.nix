{stdenv, fetchurl, unzip, ruby, makeWrapper}:

stdenv.mkDerivation {
  name = "ec2-ami-tools";
  buildInputs = [unzip makeWrapper];
  src = fetchurl {
    url = http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip;
    sha256 = "2a7c848abea286234adcbb08938cfad50b844ecdfc7770e781289d9d396a1972";
  };

  installPhase =
    ''
      ensureDir $out
      mv * $out
      rm $out/*.txt

      for i in $out/bin/*; do
          wrapProgram $i \
            --set EC2_HOME $out \
            --set PATH '$PATH:${ruby}/bin'
      done
      
      sed -i 's|/bin/bash|${stdenv.shell}/bin/bash|' $out/lib/ec2/platform/base/pipeline.rb
    ''; 

  meta = {
    homepage = http://developer.amazonwebservices.com/connect/entry.jspa?externalID=368&categoryID=88;
    description = "Command-line tools to create and manage Amazon EC2 virtual machine images";
    license = "unfree-redistributable";
  };

}
