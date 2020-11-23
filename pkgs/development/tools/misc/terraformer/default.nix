{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraformer";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = version;
    sha256 = "11j7yra0qbjadg4cb57qbdxf0di7crfv0aqam6gc1zng3fzlh4w9";
  };

  vendorSha256 = "1lsg5svdnmqiradpr4h2420y5jmml3af8pp0np1735n3wh1q1blh";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI tool to generate terraform files from existing infrastructure (reverse Terraform). Infrastructure to Code";
    homepage = "https://github.com/GoogleCloudPlatform/terraformer";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
