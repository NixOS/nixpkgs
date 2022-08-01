{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraformer";
  version = "0.8.21";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = version;
    sha256 = "sha256-IcxXR+EQItfUtUfBOlRi8VvxZ3y4OE8mdbch5KqG+wg=";
  };

  vendorSha256 = "sha256-zek9c5y6HEvY0eFdv78RDS8+Q2/++34VHRJsIONse6c=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI tool to generate terraform files from existing infrastructure (reverse Terraform). Infrastructure to Code";
    homepage = "https://github.com/GoogleCloudPlatform/terraformer";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
