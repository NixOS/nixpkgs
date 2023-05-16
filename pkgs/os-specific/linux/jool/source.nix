{ fetchFromGitHub }:

rec {
<<<<<<< HEAD
  version = "4.1.10";
=======
  version = "4.1.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-98XbBdSmgcepPZxX6hoPim+18lHLbrjqlbipB92nyAc=";
=======
    hash = "sha256-sKrjn/XQANiXfkjNiFfvAkmONyQjVigFBKgcGkuIPs0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
