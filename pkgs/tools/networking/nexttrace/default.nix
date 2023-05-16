{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nexttrace";
<<<<<<< HEAD
  version = "1.1.7-1";
=======
  version = "1.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sjlleo";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ZMbX37gi9aGamDtoTdfUMiCPieP4DhjBSE5CIJLK6Z0=";
  };
  vendorHash = "sha256-u5EIzYWr81tmMmImoRH0wT7aD3/0tx+W3CXeymWVACM=";
=======
    sha256 = "sha256-sOTQBh6j8od24s36J0e2aKW1mWmAD/ThfY6pd1SsSlY=";
  };
  vendorHash = "sha256-ckGoDV4GNp0mG+bkCKoLBO+ap53R5zrq/ZSKiFmVf9U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X github.com/xgadget-lab/nexttrace/config.Version=v${version}"
=======
    "-X github.com/xgadget-lab/nexttrace/printer.version=v${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "An open source visual route tracking CLI tool";
    homepage = "https://mtr.moe";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sharzy ];
  };
}

