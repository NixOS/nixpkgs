{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-ls";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "11776nq1ixrg791xlmryjxldsc8gn69j1fc0wd6cdywy8yp2lh4w";
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
