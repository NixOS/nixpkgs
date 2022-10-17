{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tar2ext4";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${version}";
    sha256 = "sha256-P2ri+9MDV6ObyAiqUguifjqkPg+8zE+Ha6jgFS5aCsQ=";
  };

  sourceRoot = "source/cmd/tar2ext4";
  vendorSha256 = null;

  meta = with lib; {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
  };
}
