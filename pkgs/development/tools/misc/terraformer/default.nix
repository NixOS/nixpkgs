{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraformer";
  version = "0.8.19";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = version;
    sha256 = "sha256-h6hqgAHyMNnE7AXNPTUM2srgHW9WGcGmO8d30U2IbSo=";
  };

  vendorSha256 = "sha256-bT6+fH0VJfcgehiiLIDTEYyWgVHIMUGuRaebzm2st60=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI tool to generate terraform files from existing infrastructure (reverse Terraform). Infrastructure to Code";
    homepage = "https://github.com/GoogleCloudPlatform/terraformer";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
