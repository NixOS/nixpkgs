{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tar2ext4";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${version}";
    sha256 = "sha256-iz8trRuGyIpGbRX+qYyKKS9gR8daLTRzKmlxE94eDzo=";
  };

  sourceRoot = "${src.name}/cmd/tar2ext4";
  vendorHash = null;

  meta = with lib; {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
  };
}
