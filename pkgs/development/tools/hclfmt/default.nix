{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hclfmt";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    rev = "v${version}";
    hash = "sha256-Rx073Ob7CqaPEGIskJHW/xmt4S+WE/AWKewXpjY3kQ4=";
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
