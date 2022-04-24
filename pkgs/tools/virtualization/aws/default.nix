{ lib, stdenv, fetchurl, perl, curl }:

stdenv.mkDerivation {
  pname = "aws";
  version = "2019.06.18";

  src = fetchurl {
    url = "https://raw.github.com/timkay/aws/ac68eb5191c52f069b9aa0c9a99808f8a4430833/aws";
    sha256 = "02bym9wicqpdr7mdim13zw5ssh97xfswzab9q29rsbg7058ddbil";
  };

  buildInputs = [ perl ];

  dontUnpack = true;

  installPhase =
    ''
      mkdir -p $out/bin
      sed 's|\[curl|[${curl.bin}/bin/curl|g' $src > $out/bin/aws
      chmod +x $out/bin/aws
    '';

  meta = {
    homepage = "https://www.timkay.com/aws/";
    description = "Command-line utility for working with Amazon EC2, S3, SQS, ELB, IAM and SDB";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
