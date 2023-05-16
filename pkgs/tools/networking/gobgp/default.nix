{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gobgp";
<<<<<<< HEAD
  version = "3.18.0";
=======
  version = "3.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-OAePH8q8YQJGundd0VwtLEl3UkRyuZYAx5rcN4DNft4=";
=======
    sha256 = "sha256-R64Mm8fWZ8VZgsKcnc+ZqAk0V3L+TkpxTmSkx6+KVs0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-Z7vYpDQIKc4elVBLiGtxF3D9pec4QNvWFLpux/29t1Y=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s" "-w" "-extldflags '-static'"
  ];

  subPackages = [ "cmd/gobgp" ];

  meta = with lib; {
    description = "A CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
  };
}
