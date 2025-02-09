{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zfsbackup";
  version = "unstable-2022-09-23";
  rev = "a30f1a44bcae5f64cfb36a12926242a968a759c6";

  src = fetchFromGitHub {
    owner = "someone1";
    repo = "zfsbackup-go";
    inherit rev;
    sha256 = "sha256-ZJ7gtT4AdMLEs2+hJa2Sia0hSoQd3CftdqRsH/oJxd8=";
  };

  vendorHash = "sha256-aYAficUFYYhZygfQZyczP49CeouAKKZJW8IFlkFh9lI=";

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
