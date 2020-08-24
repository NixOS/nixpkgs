{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-ls";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yhpxb9dkwi6rlabr0sd5rk15q0bin6yhww171jrzlnfl036l0sl";
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
