{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wwdnqb34l0ad6hlvs74acfh0744ir3ssm8wjwpxbsy0sxkrpxcf";
  };

  modSha256 = "1jbnsqa0ga372lhbgfnqvx8pdzrm0b2phzzwll4sgd0k1hzv2aqv";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
