{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-s3-exporter";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ribbybibby";
    repo = "s3_exporter";
    rev = "v${version}";
    sha256 = "sha256-dYkMCCAIlFDFOFUNJd4NvtAeJDTsHeJoH90b5pSGlQE=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Exports Prometheus metrics about S3 buckets and objects";
    homepage = "https://github.com/ribbybibby/s3_exporter";
    license = licenses.asl20;
    maintainers = [ maintainers.mmahut ];
  };
}
