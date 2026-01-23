{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "aws-s3-exporter";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ribbybibby";
    repo = "s3_exporter";
    rev = "v${version}";
    sha256 = "sha256-dYkMCCAIlFDFOFUNJd4NvtAeJDTsHeJoH90b5pSGlQE=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Exports Prometheus metrics about S3 buckets and objects";
    mainProgram = "s3_exporter";
    homepage = "https://github.com/ribbybibby/s3_exporter";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mmahut ];
  };
}
