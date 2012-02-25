{ stdenv, fetchurl, unzip, ruby, openssl, makeWrapper }:

stdenv.mkDerivation {
  name = "ec2-ami-tools-1.4.0.5";
  
  buildInputs = [ unzip makeWrapper ];
  
  src = fetchurl {
    url = http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip;
    sha256 = "0vhdqmi076ipqj05dd7fn0drbhcvzccdcdhy8br9sp684scg9a75";
  };

  # Amazon EC2 requires that disk images are writable.  If they're
  # not, the VM immediately terminates with a mysterious
  # "Server.InternalError" message.  Since disk images generated in
  # the Nix store are read-only, they must be made writable in the
  # tarball uploaded to Amazon S3.  So add a `--mode=0755' flag to the
  # tar invocation.
  patches = [ ./writable.patch ];

  installPhase =
    ''
      mkdir -p $out
      mv * $out
      rm $out/*.txt

      for i in $out/bin/*; do
          wrapProgram $i \
            --set EC2_HOME $out \
            --prefix PATH : ${ruby}/bin:${openssl}/bin
      done
      
      sed -i 's|/bin/bash|${stdenv.shell}|' $out/lib/ec2/platform/base/pipeline.rb
    '';  # */

  meta = {
    homepage = http://developer.amazonwebservices.com/connect/entry.jspa?externalID=368&categoryID=88;
    description = "Command-line tools to create and manage Amazon EC2 virtual machine images";
    license = "unfree-redistributable";
  };

}
