{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scilla";
<<<<<<< HEAD
  version = "1.2.7";
=======
  version = "1.2.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-gZuNXQaxHJYLsEaOpNYo7ybg3f0GhkpiaLrex5lkDu4=";
  };

  vendorHash = "sha256-bVGmleuOJzi/Sz7MJlnQuJsDgRWuwieLUx8hcyKkWXI=";

  checkFlags = [
    # requires network access
    "-skip=TestIPToHostname"
  ];
=======
    rev = "v${version}";
    sha256 = "sha256-8ZRYgQ4xME71vlO0nKnxiCqeju0G4SwgEXnUol1jQxk=";
  };

  vendorSha256 = "sha256-Y4Zi0Hy6ydGxLTohgJGF3L9O+79z+3t+4ZA64otCJpE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Information gathering tool for DNS, ports and more";
    homepage = "https://github.com/edoardottt/scilla";
<<<<<<< HEAD
    changelog = "https://github.com/edoardottt/scilla/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
