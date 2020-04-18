{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "zfsbackup";
  version = "unstable-2019-03-05";
  rev = "78fea6e99f0a5a4c8513d3a3d1d45fb6750cfddf";

  goPackagePath = "github.com/someone1/zfsbackup-go";

  src = fetchFromGitHub {
    owner = "someone1";
    repo = "zfsbackup-go";
    inherit rev;
    sha256 = "0yalsfvzmcnc8yfzm3r5dikqrp57spwa16l7gbzvgqqcz4vlnw3n";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Backup ZFS snapshots to cloud storage such as Google, Amazon, Azure, etc";
    homepage = "https://github.com/someone1/zfsbackup-go";
    license = licenses.mit;
    maintainers = [ maintainers.xfix ];
  };
}
