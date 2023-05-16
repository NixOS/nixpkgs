<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.3.2";
=======
{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-pzAL7e72sO94qLEwsH/5RuiuzvnsSelIq47jdU8INDw=";
  };

  cargoHash = "sha256-gDOZ3nD7pTIRNXG3S+qTkl+HInBcAErvwPqa0NZWxY4=";
=======
    sha256 = "sha256-XUxoHmZePn/VVlu2KctC+TbmCwp+tYEYg5EYXI8ZB7o=";
  };

  cargoSha256 = "sha256-RyEqDC2gRacd27uvNf3XOATZdeVg70vBEdPURNuf38w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
<<<<<<< HEAD
    changelog = "https://github.com/yaa110/nomino/releases/tag/${src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
