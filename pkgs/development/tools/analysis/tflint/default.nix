{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-u2k812oGePSxhWkU2iXzIRnZFfnECXPV5Ocq9jwywb4=";
  };

  vendorSha256 = "sha256-W9dKOxyLIplCQVOJGMvdSsaOFfUkCiS615NVzQFR+DM=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
