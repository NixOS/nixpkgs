{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sshportal";
<<<<<<< HEAD
  version = "1.19.5";
=======
  version = "1.19.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "moul";
    repo = "sshportal";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-XJ8Hgc8YoJaH2gYOvoYhcpY4qgasgyr4M+ecKJ/RXTs=";
=======
    sha256 = "sha256-8+UHG4xTH9h1IvMoOY7YHPClk4t2vWSBOUnYU6+mynQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [ "-X main.GitTag=${version}" "-X main.GitSha=${version}" "-s" "-w" ];

<<<<<<< HEAD
  vendorHash = "sha256-4dMZwkLHS14OGQVPq5VaT/aEpHEJ/4b2P6q3/WiDicM=";
=======
  vendorSha256 = "sha256-swDoQeO44fkpS2JNUAXaj3ZVjjzhoEr34YZ1/ArnLBk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Simple, fun and transparent SSH (and telnet) bastion server";
    homepage = "https://manfred.life/sshportal";
    license = licenses.asl20;
    maintainers = with maintainers; [ zaninime ];
  };
}
