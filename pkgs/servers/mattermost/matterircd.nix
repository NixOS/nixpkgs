{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterircd";
<<<<<<< HEAD
  version = "0.27.1";
=======
  version = "0.27.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-bDM+P9UwH4cpieOQQfEi2xIKTRQ1zInW9iFK3yAU1Xk=";
=======
    sha256 = "sha256-gJHFAvgEZ26Jj3MfaUB7u/8jWtVHa9mjWfo+hFfo9u0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Minimal IRC server bridge to Mattermost";
    homepage = "https://github.com/42wim/matterircd";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
