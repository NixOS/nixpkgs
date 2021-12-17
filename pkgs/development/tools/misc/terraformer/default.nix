{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraformer";
  version = "0.8.18";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = version;
    sha256 = "sha256-F+OmeXCb0Q2Qqu0T+dqdxvUYszg4ED/zoayH9iO6PCM=";
  };

  vendorSha256 = "sha256-MCw5EkGjQDY75lpCA6iwuAhOXOAnDuDM+9L7eBnagEU=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI tool to generate terraform files from existing infrastructure (reverse Terraform). Infrastructure to Code";
    homepage = "https://github.com/GoogleCloudPlatform/terraformer";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
