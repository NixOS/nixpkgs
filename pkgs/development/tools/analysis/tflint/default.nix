{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.20.3";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zy6v1srm5v6bg2rqb3hb4cz8g7zwhraf91y810y9csh6r4fv29b";
  };

  vendorSha256 = "0s367ikq6y1izjim72lnqc98vypl072nimcwnw9y9d7nld5y77c8";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
