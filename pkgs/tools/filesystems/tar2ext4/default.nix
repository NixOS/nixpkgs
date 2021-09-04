{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tar2ext4";
  version = "0.8.21";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "v${version}";
    sha256 = "sha256-oYCL6agif/BklMY5/ub6PExS6D/ZlTxi1QaabMOsEfw=";
  };

  sourceRoot = "source/cmd/tar2ext4";
  vendorSha256 = null;

  meta = with lib; {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
  };
}
