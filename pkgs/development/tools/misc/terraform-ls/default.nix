{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-ls";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "05cij0qh1czxnms4zjyycidx84brsmlqw1c6fpk5yv58g3v8d3v7";
  };

  goPackagePath = "github.com/hashicorp/terraform-ls";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Terraform Language Server (official)";
    homepage = "https://github.com/hashicorp/terraform-ls";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mbaillie ];
  };
}
