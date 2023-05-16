{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "f2";
<<<<<<< HEAD
  version = "1.9.1";
=======
  version = "1.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-vpyI6WtK/0UpPiB8y+HpPd0IsKKkMHa/eIreYo32iAA=";
  };

  vendorHash = "sha256-Bz3Igjcyq4rkMkgv1J3+JiAqroAjxyAvHw4d4eZJgAM=";
=======
    sha256 = "sha256-2+wp9hbPDH8RAeQNH1OYDfFlev+QTsEHixYb/luR9F0=";
  };

  vendorHash = "sha256-sOTdP+MuOH9jB3RMajeUx84pINSuWVRw5p/9lrOj6uo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Command-line batch renaming tool";
    homepage = "https://github.com/ayoisaiah/f2";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
