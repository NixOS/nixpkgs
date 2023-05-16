{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
<<<<<<< HEAD
  version = "20230606";
=======
  version = "20230404.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-F4muuU696YbKcPkpD1LAeyD8ghQAe65UdqV5wS1fATI=";
=======
    sha256 = "sha256-79fH5Bmpg9qMyec1GtyGqme+QBw/Yfs5xMEo9tJXHuU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-uKlO1x5sGM8B1htmvRt9kND7tuH36iLN/Mev77vwZ6M=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ xrelkd ];
  };
}
