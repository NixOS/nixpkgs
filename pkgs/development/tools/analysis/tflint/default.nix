{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mdxs019vzpfxaqkw4nb79p3rydril0ihbn55n4yyh0fznv6zzxi";
  };

  modSha256 = "0ksblhra7ln4ryggr2x8fzl8a7ljz5zdjgdxz82c75wd7wdbw8f5";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
