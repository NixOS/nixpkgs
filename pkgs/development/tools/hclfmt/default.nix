{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hclfmt";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    rev = "v${version}";
    hash = "sha256-XH/qSl16LQThj9ghwlSGJuSsez7VxsZS9Sun7F2sT7Y=";
  };

  vendorSha256 = "sha256-9IGHILgByNFviQcHJCFoEX9cZif1uuHCu4xvmGZYoXk=";

  # The code repository includes other tools which are not useful. Only build
  # hclfmt.
  subPackages = [ "cmd/hclfmt" ];

  meta = with lib; {
    description = "a code formatter for the Hashicorp Configuration Language (HCL) format";
    homepage = "https://github.com/hashicorp/hcl/tree/main/cmd/hclfmt";
    license = licenses.mpl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
