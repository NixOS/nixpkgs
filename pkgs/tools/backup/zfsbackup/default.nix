{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "zfsbackup";
  version = "unstable-2020-09-30";
  rev = "092f80846b23e02f99d2aa72d9d889eabfdcb053";

  goPackagePath = "github.com/someone1/zfsbackup-go";

  src = fetchFromGitHub {
    owner = "someone1";
    repo = "zfsbackup-go";
    inherit rev;
    sha256 = "1xiacaf4r9jkx0m8wjfis14cq622yhljldwkflh9ni3khax7dlgi";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Backup ZFS snapshots to cloud storage such as Google, Amazon, Azure, etc";
    homepage = "https://github.com/someone1/zfsbackup-go";
    license = licenses.mit;
    maintainers = [ maintainers.xfix ];
    mainProgram = "zfsbackup-go";
  };
}
