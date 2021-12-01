{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "aws-s3-exporter";
  version = "0.4.1";

  goPackagePath = "github.com/ribbybibby/s3_exporter";

  src = fetchFromGitHub {
    owner = "ribbybibby";
    repo = "s3_exporter";
    rev = "v${version}";
    sha256 = "01g4k5wrbc2ggxkn4yqd2v0amw8yl5dbcfwi4jm3kqkihrf0rbiq";
  };

  doCheck = true;

  meta = with lib; {
    description = "Exports Prometheus metrics about S3 buckets and objects";
    homepage = "https://github.com/ribbybibby/s3_exporter";
    license = licenses.asl20;
    maintainers = [ maintainers.mmahut ];
  };
}
