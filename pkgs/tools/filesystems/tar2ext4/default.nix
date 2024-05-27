{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tar2ext4";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${version}";
    sha256 = "sha256-xBlol+09rogbNSYM6Ok5EWb6IEfrVb+/wNMqAA3ZELU=";
  };

  sourceRoot = "${src.name}/cmd/tar2ext4";
  vendorHash = null;

  meta = with lib; {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
    mainProgram = "tar2ext4";
  };
}
