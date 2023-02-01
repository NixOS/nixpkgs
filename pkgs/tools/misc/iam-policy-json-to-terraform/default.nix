{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "iam-policy-json-to-terraform";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "flosell";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-ovmWZpeHt1L8zNzG7+2BohteSjpYADMivi+AP0Vm8/E=";
  };

  vendorHash = "sha256-1WTc7peTJI3IvHJqznqRz29uQ2NG0CZpAAzlyYymZCQ=";

  meta = with lib; {
    description = "Small tool to convert an IAM Policy in JSON format into a Terraform aws_iam_policy_document ";
    homepage = "https://github.com/flosell/iam-policy-json-to-terraform";
    changelog = "https://github.com/flosell/iam-policy-json-to-terraform/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
