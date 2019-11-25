{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ivvx1nbhzijyiv9q05b5953wxga5wdskamnhfvlwpniabic3gxi";
  };

  modSha256 = "0q1sc0bj4a29rzly4fk6m40b8i7syxa7ff9882jwi7gxjdiklch3";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/terraform-linters/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
