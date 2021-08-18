{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tar2ext4";
  version = "0.8.20";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${version}";
    sha256 = "sha256-X7JsUFL9NkNT7ihE5olrqMUP8RnoVC10KLrQeT/OU3o=";
  };

  sourceRoot = "source/cmd/tar2ext4";
  vendorSha256 = null;

  meta = with lib; {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
