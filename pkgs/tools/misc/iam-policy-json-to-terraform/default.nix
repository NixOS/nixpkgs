{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "iam-policy-json-to-terraform";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "flosell";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-O3JlBWT2YVu3mv/BCbs65k7HMF4cRCihd59wZzeoxcI=";
  };

  vendorSha256 = "sha256-IXWt/yFapDamfZClI6gm5vPA5VW2gV2iEq5c/nJXiiA=";

  meta = with lib; {
    description = "Small tool to convert an IAM Policy in JSON format into a Terraform aws_iam_policy_document ";
    homepage = "https://github.com/flosell/iam-policy-json-to-terraform";
    changelog = "https://github.com/flosell/iam-policy-json-to-terraform/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
