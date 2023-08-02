{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tar2ext4";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${version}";
    sha256 = "sha256-+GhYeQ27uwg9JOv1qbf1+UbMd+vPXJ05nsXZD9OakzI=";
  };

  sourceRoot = "source/cmd/tar2ext4";
  vendorHash = null;

  meta = with lib; {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
  };
}
