{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "bomber-go";
<<<<<<< HEAD
  version = "0.4.4";
=======
  version = "0.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "devops-kung-fu";
    repo = "bomber";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-vFdXtkz2T6kP/j/j9teHpf4XesqOmKFliZJRyGZKdwg=";
  };

  vendorHash = "sha256-GHzJQVq748kG+X9amsQmqZ2cRzwQDO5LfBqvZwVn6W8=";
=======
    hash = "sha256-q30wTM8HQURDBUReQsXgKHI4m4sSdHbWPwUld0sAays=";
  };

  vendorHash = "sha256-tkjwnc5EquAuIfYKy8u6ZDFJPl/UTW6x7vvY1QTsBXg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-w"
    "-s"
  ];

<<<<<<< HEAD
  checkFlags = [
    "-skip=TestEnrich" # Requires network access
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Tool to scans Software Bill of Materials (SBOMs) for vulnerabilities";
    homepage = "https://github.com/devops-kung-fu/bomber";
    changelog = "https://github.com/devops-kung-fu/bomber/releases/tag/v${version}";
    license = licenses.mpl20;
    mainProgram = "bomber";
    maintainers = with maintainers; [ fab ];
  };
}
