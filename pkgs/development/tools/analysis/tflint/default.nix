{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.39.2";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TOI3rkh6v0Ewo+gPo8N7at1orbSTjQkEZKA6sYDv0u8=";
  };

  vendorSha256 = "sha256-6sk1bFuSCrKt9uMrrwOpX/SBZrjFvtqVPFylbRNHpz4=";

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
