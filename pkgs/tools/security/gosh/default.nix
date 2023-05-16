{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosh";
<<<<<<< HEAD
  version = "1.0.0";
=======
  # https://github.com/redcode-labs/GoSH/issues/4
  version = "2020523-${lib.strings.substring 0 7 rev}";
  rev = "7ccb068279cded1121eacc5a962c14b2064a1859";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "GoSH";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-h4WqaN2okAeaU/+0fs8zLYDtyQLuLkCDdGrkGz8rdhg=";
  };

  vendorHash = "sha256-ITz6nkhttG6bsIZLsp03rcbEBHUQ7pFl4H6FOHTXIU4=";
=======
    inherit rev;
    sha256 = "143ig0lqnkpnydhl8gnfzhg613x4wc38ibdbikkqwfyijlr6sgzd";
  };

  vendorSha256 = "sha256-ITz6nkhttG6bsIZLsp03rcbEBHUQ7pFl4H6FOHTXIU4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "Reverse/bind shell generator";
    homepage = "https://github.com/redcode-labs/GoSH";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ] ++ teams.redcodelabs.members;
    mainProgram = "GoSH";
  };
}
