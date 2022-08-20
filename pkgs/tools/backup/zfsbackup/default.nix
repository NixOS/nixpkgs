{ lib
, buildGoModule
, fetchFromGitHub
, zfs
}:

buildGoModule rec {
  pname = "zfsbackup";
  version = "unstable-2021-05-26";
  rev = "2d4534b920d3c57552667e1c6da9978b3a9278f0";

  src = fetchFromGitHub {
    owner = "someone1";
    repo = "zfsbackup-go";
    inherit rev;
    sha256 = "sha256-slVwXXGLvq+eAlqzD8p1fnc17CGUBY0Z68SURBBuf2k=";
  };

  vendorSha256 = "sha256-jpxp8RKDBrkBBaY89QnKYGWFI/DUURUVX8cPJ/qoLrg=";

  ldflags = [ "-w" "-s" ];

  # Tests require loading the zfs kernel module.
  doCheck = false;

  meta = with lib; {
    description = "Backup ZFS snapshots to cloud storage such as Google, Amazon, Azure, etc";
    homepage = "https://github.com/someone1/zfsbackup-go";
    license = licenses.mit;
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux;
    mainProgram = "zfsbackup-go";
  };
}
