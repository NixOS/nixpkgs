{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hclfmt";
  version = "2.18.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    rev = "v${version}";
    hash = "sha256-31Xqgzd208ypK8u1JV5Rh5cCqGr1MJkLP490nIeovsE=";
  };

  vendorHash = "sha256-DA1IKaC+YSBzCfEMqHsHfwu1o5qvYFaFgDoGG0RZnoo=";

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
