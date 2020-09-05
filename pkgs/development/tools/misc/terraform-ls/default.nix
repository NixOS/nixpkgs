{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "terraform-ls";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1afdd1zs242nh1cync5ip1fbah34wc3gbsx3hwwiisc8yziwiq18";
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
