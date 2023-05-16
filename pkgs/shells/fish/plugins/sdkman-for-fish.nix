{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "sdkman-for-fish";
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "reitzig";
    repo = "sdkman-for-fish";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cgDTunWFxFm48GmNv21o47xrXyo+sS6a3CzwHlv0Ezo=";
=======
    hash = "sha256-bfWQ2al0Xy8bnJt5euziHz/+qhyri4qWy47VDoPwQcg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Adds support for SDKMAN! to fish";
    homepage = "https://github.com/reitzig/sdkman-for-fish";
    license = licenses.mit;
    maintainers = with maintainers; [ giorgiga ];
  };
}
