{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xcaddy";
<<<<<<< HEAD
  version = "0.3.5";
=======
  version = "0.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/xcaddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XxklyOaKFPyWFabodNCcV1NnaPWS0AQ2Sj89ZZ5hJbk=";
=======
    hash = "sha256-HDyHvHa8yCz59AifHxQ0LAuC/xPXQInuUYURx7bL3oE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./inject_version_info.diff
    ./use_tmpdir_on_darwin.diff
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/caddyserver/xcaddy/cmd.customVersion=v${version}"
  ];

  vendorHash = "sha256-RpbnoXyTrqGOI7DpgkO+J47P17T4QCVvM1CfS6kRO9Y=";

  meta = with lib; {
    homepage = "https://github.com/caddyserver/xcaddy";
    description = "Build Caddy with plugins";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ tjni emilylange ];
=======
    maintainers = with maintainers; [ tjni indeednotjames ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
