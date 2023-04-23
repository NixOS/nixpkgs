{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraformer";
  version = "0.8.22";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = version;
    sha256 = "sha256-TuzQ9qIpioKK4tc1J9Spxt52716Z3yTEufyaRDL57gI=";
  };

  vendorSha256 = "sha256-fcCvwjqSTeFo0AwTVwWTdygvIPf0EUnZkWqNrQ6eugI=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI tool to generate terraform files from existing infrastructure (reverse Terraform). Infrastructure to Code";
    homepage = "https://github.com/GoogleCloudPlatform/terraformer";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
