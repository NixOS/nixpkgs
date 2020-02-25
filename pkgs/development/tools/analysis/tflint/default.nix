{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j1bx2180z6znfrg8k4sjwvm3cbvnklqjxdssbr2yd47h8kfwk3g";
  };

  modSha256 = "1qa7qfxpc43n9xyyfcd24d17g4fdcffkd57ny078ja219x13kay3";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
