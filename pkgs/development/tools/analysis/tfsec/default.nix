{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tfsec";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mmh161zwrkjwpw01zcgh7hsap7lgdxhg191bajzig6vlq287jyh";
  };

  goPackagePath = "github.com/liamg/tfsec";

  meta = with lib; {
    homepage = "https://github.com/liamg/tfsec";
    description = "Static analysis powered security scanner for your terraform code";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
