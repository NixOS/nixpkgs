{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "awsls";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "jckuester";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iy9tohmVUtNXYVfe6pZ+pbbLlcK6Fu1GgzTWMD+3xP0=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-ZyMO+KCqoePF6MqHFt8X4tZR4nBhuSPgJDrX+emM6jc=";
=======
  vendorSha256 = "sha256-ZyMO+KCqoePF6MqHFt8X4tZR4nBhuSPgJDrX+emM6jc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags =
    let t = "github.com/jckuester/awsls/internal";
    in [ "-s" "-w" "-X ${t}.version=${version}" "-X ${t}.commit=${src.rev}" "-X ${t}.date=unknown" ];

  doCheck = false;

  meta = with lib; {
    description = "A list command for AWS resources";
    homepage = "https://github.com/jckuester/awsls";
    license = licenses.mit;
    maintainers = [ maintainers.markus1189 ];
  };
}
