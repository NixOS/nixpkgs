{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jwt-hack";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-K0ZtEi0zAKRlIGvorrXmtmkcMvyLIXWPnVMQANZbClk=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-VYh3oRy8bmtXf6AnLNi/M2kA6t+crW3AXBiGovpdt8U=";
=======
  vendorSha256 = "sha256-VYh3oRy8bmtXf6AnLNi/M2kA6t+crW3AXBiGovpdt8U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool for attacking JWT";
    homepage = "https://github.com/hahwul/jwt-hack";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
