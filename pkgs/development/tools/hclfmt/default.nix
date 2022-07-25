{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hclfmt";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    rev = "v${version}";
    hash = "sha256-tL0jkddKmfQu3a4BDw/RCwQqhRrPf9XWXHl/nG09yVc=";
  };

  vendorSha256 = "sha256-Wa0tDgHgSPVY6GNxCv9mGWSSi/NuwZq1VO+jwUCMvNI=";

  # The code repository includes other tools which are not useful. Only build
  # hclfmt.
  subPackages = [ "cmd/hclfmt" ];

  meta = {
    description = "a code formatter for the Hashicorp Configuration Language (HCL) format";
    homepage = "https://github.com/hashicorp/hcl/tree/main/cmd/hclfmt";
    license = lib.licenses.mpl20;
    maintainers = [
      lib.maintainers.zimbatm
    ];
  };
}
