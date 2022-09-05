{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "txtpbfmt";
  version = "unstable-2022-06-08";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "fc78c767cd6a4e6e3953f5d72f1e0e4c5811990b";
    sha256 = "sha256-5Pj2REFrzWCzrqdplNlyfX+sJqPjXEld6MFNy0S3MFM=";
  };

  vendorSha256 = "sha256-shjcQ3DJQYeAW0bX3OuF/esgIvrQ4yuLEa677iFV82g=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Formatter for text proto files";
    homepage = "https://github.com/protocolbuffers/txtpbfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
