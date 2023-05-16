{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pup";
<<<<<<< HEAD
  version = "unstable-2022-03-06";
=======
  version = "unstable-2019-09-19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ericchiang";
    repo = "pup";
<<<<<<< HEAD
    rev = "5a57cf111366c7c08999a34b2afd7ba36d58a96d";
    hash = "sha256-Ledg3xPbu71L5qUY033bru/lw03jws3s4YlAarIuqaA=";
  };

  vendorHash = "sha256-/MDSWIuSYNxKbTslqIooI2qKA8Pye0yJF2dY8g8qbWI=";
=======
    rev = "681d7bb639334bf485476f5872c5bdab10931f9a";
    sha256 = "1hx1k0qlc1bq6gg5d4yprn4d7kvqzagg6mi5mvb39zdq6c4y17vr";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Parsing HTML at the command line";
    homepage = "https://github.com/ericchiang/pup";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ yana ];
=======
    maintainers = with maintainers; [ SuperSandro2000 yana ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
