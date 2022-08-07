{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "iam-policy-json-to-terraform";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "flosell";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-1OQvm3M/n/8F3QHNfPlq9YQVyV97NlHX3dXWA/VXEZU=";
  };

  vendorSha256 = "sha256-Fn5GgGW9QhnQOKV34Kzl1Yctv3XLQ51lCuuGx5kvlIA=";

  meta = with lib; {
    description = "Small tool to convert an IAM Policy in JSON format into a Terraform aws_iam_policy_document ";
    homepage = "https://github.com/flosell/iam-policy-json-to-terraform";
    changelog = "https://github.com/flosell/iam-policy-json-to-terraform/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
