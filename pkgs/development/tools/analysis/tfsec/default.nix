{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tfsec";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ddyvkv0949p0b6m1rwai5r87mca5xwyjwsjq7gbyqz9h10bv7nf";
  };

  goPackagePath = "github.com/liamg/tfsec";

  meta = with lib; {
    homepage = "https://github.com/liamg/tfsec";
    description = "Static analysis powered security scanner for your terraform code";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
