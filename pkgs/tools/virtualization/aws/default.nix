{ stdenv, fetchurl, perl, curl }:

stdenv.mkDerivation {
  name = "aws-1.75";
  
  src = fetchurl {
    url = https://raw.github.com/timkay/aws/2f2ff99f9f5111ea708ae6cd14d20e264748e72b/aws;
    sha256 = "0d5asv73a58yb1bb1jpsw3c7asd62y86z5fwpg4llhjzkx79maj6";
  };

  buildInputs = [ perl ];

  unpackPhase = "true";

  installPhase =
    ''
      mkdir -p $out/bin
      sed 's|\[curl|[${curl}/bin/curl|g' $src > $out/bin/aws
      chmod +x $out/bin/aws
    '';

  meta = {
    homepage = http://www.timkay.com/aws/;
    description = "Command-line utility for working with Amazon EC2, S3, SQS, ELB, IAM and SDB";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
