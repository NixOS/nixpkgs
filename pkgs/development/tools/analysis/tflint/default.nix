{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wbxlh2lwgdhhw902lqy6p2vh8adfq4yaa507js8an3byy26ls3d";
  };

  vendorSha256 = "0yk9xsb0s4kymfb3p14irks6b30b53r0mz7irgcmx9jxz8vyffqg";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
