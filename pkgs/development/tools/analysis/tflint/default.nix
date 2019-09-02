{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "1p4w1ddgb4nqibbrvix0p0gdlj6ann5lkyvlcsbkn25z8ha3qa39";
  };

  modSha256 = "1snanz4cpqkfgxp8k52w3x4i49k6d5jffcffrcx8xya8yvx2wxy3";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
