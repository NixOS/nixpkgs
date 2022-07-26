{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.38.1";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sBvfcAOkfZ5V7SrLBWrSQr5zXwqbwOBmYehujk0y6eg=";
  };

  vendorSha256 = "sha256-2v070TwDWkN4HZ/EOu85lotA9qIKLgpwD9TrfH7pGY4=";

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
