{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ddosify";
<<<<<<< HEAD
  version = "1.0.5";
=======
  version = "0.16.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-oCbEAEBZJsMnnVu2N6eiQiaywovWmGUSVpUyWyS7TpM=";
  };

  vendorHash = "sha256-cGhMhX+SEv9fejViLZrEwXg584o204OQ5iR6AkxKnXo=";
=======
    sha256 = "sha256-AWYUJalXggNJonYE71c9uH+ebAms1LJTLcYgHzmUzR0=";
  };

  vendorHash = "sha256-/kxHK3dX1RXB3Z5suSKsTHF7xaklCoyzUTbU1lcYwwg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s" "-w"
    "-X main.GitVersion=${version}"
    "-X main.GitCommit=unknown"
    "-X main.BuildDate=unknown"
  ];

  # TestCreateHammerMultipartPayload error occurred - Get "https://upload.wikimedia.org/wikipedia/commons/b/bd/Test.svg"
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/ddosify -version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "High-performance load testing tool, written in Golang";
    homepage = "https://ddosify.com/";
    changelog = "https://github.com/ddosify/ddosify/releases/tag/v${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
