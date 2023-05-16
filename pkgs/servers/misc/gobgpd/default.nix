{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gobgpd";
<<<<<<< HEAD
  version = "3.18.0";
=======
  version = "3.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-OAePH8q8YQJGundd0VwtLEl3UkRyuZYAx5rcN4DNft4=";
=======
    hash = "sha256-R64Mm8fWZ8VZgsKcnc+ZqAk0V3L+TkpxTmSkx6+KVs0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-Z7vYpDQIKc4elVBLiGtxF3D9pec4QNvWFLpux/29t1Y=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  subPackages = [
    "cmd/gobgpd"
  ];

  meta = with lib; {
    description = "BGP implemented in Go";
    homepage = "https://osrg.github.io/gobgp/";
    changelog = "https://github.com/osrg/gobgp/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
  };
}
