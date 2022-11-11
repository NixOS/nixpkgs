{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tar2ext4";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${version}";
    sha256 = "sha256-p64BQlxwXU9+6MbT2Aw9EcW82t2i3E6mKfOWoEEFf9g=";
  };

  sourceRoot = "source/cmd/tar2ext4";
  vendorSha256 = null;

  meta = with lib; {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
  };
}
