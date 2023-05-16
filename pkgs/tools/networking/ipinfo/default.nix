{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ipinfo";
<<<<<<< HEAD
  version = "3.0.1";
=======
  version = "2.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = "refs/tags/${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-b6Rh5TJHqcdexZ4AHY+4jQsCMdn69J3MTbmgKXEaACw=";
  };

  vendorHash = null;
=======
    hash = "sha256-/CW+CmtKc96tVEh5cB6x+/Hb4WnbVi+3AZ0CEao0NE4=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Command Line Interface for the IPinfo API";
    homepage = "https://github.com/ipinfo/cli";
    changelog = "https://github.com/ipinfo/cli/releases/tag/ipinfo-${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
