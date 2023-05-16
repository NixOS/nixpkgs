{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "subfinder";
<<<<<<< HEAD
  version = "2.6.3";
=======
  version = "2.5.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-X1Ow11ECwu2a/VzimrKGRJKCnZWL8KJ5Gii+pjP5b9E=";
  };

  vendorHash = "sha256-T1xrJ44xB95+ZhQPCYlcbH1gIQm7ETtTnQLl/+TRxVA=";
=======
    sha256 = "sha256-/q6ES1fW9/vxe03w73VyAHfOZNK6g5hxwi3qhxCiN6M=";
  };

  vendorHash = "sha256-sUkSxpWDqBe15BFVGNHTF1lV2mXZ0kjevMvdHtuNjXs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  modRoot = "./v2";

  subPackages = [
    "cmd/subfinder/"
  ];

  meta = with lib; {
    description = "Subdomain discovery tool";
    longDescription = ''
      SubFinder is a subdomain discovery tool that discovers valid
      subdomains for websites. Designed as a passive framework to be
      useful for bug bounties and safe for penetration testing.
    '';
    homepage = "https://github.com/projectdiscovery/subfinder";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ fpletz Br1ght0ne Misaka13514 ];
=======
    maintainers = with maintainers; [ fpletz Br1ght0ne ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
