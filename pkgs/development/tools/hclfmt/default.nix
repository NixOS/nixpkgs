{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hclfmt";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    rev = "v${version}";
    hash = "sha256-7RHRUIZhF6UOZDi85HAzQhzD7c8Y4aPjt4Ly3KUM26k=";
  };

  vendorHash = "sha256-QZzDFVAmmjkm7n/KpMxDMAjShKiVVGZbZB1W3/TeVjs=";

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
