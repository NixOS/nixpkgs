{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hclfmt";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    rev = "v${version}";
    hash = "sha256-gXipXBi/IFB4F+vr1BBp91kcIRpWvxkSttb62Cl3h0g=";
  };

  vendorHash = "sha256-MXiLfCbXXw2PMlj/3eAvbReH11IzS/G/4ajV37B5lOs=";

  # The code repository includes other tools which are not useful. Only build
  # hclfmt.
  subPackages = [ "cmd/hclfmt" ];

  meta = with lib; {
    description = "a code formatter for the Hashicorp Configuration Language (HCL) format";
    homepage = "https://github.com/hashicorp/hcl/tree/main/cmd/hclfmt";
    license = licenses.mpl20;
    mainProgram = "hclfmt";
    maintainers = with maintainers; [ zimbatm ];
  };
}
