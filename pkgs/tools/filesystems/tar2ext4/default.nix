{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tar2ext4";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${version}";
    sha256 = "sha256-aK1XZPHZSgTf6MTrJv+5SBr7FCT53VNXSTZQVnHM2GA=";
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
