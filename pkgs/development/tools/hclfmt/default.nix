{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hclfmt";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    rev = "v${version}";
    hash = "sha256-6OALbouj1b6Jbtv0znpkfgYS4MyBpxQ56Sen3OJYaHs=";
  };

  vendorHash = "sha256-SjewF3q4vQ3oWR+vxqpZVP6St8db/GXezTDWYUeK2g8=";

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
