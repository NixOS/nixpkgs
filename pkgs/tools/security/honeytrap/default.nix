{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule {
  pname = "honeytrap";
<<<<<<< HEAD
  version = "unstable-2021-12-20";
=======
  version = "unstable-2020-12-10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "honeytrap";
    repo = "honeytrap";
<<<<<<< HEAD
    rev = "05965fc67deab17b48e43873abc5f509067ef098";
    hash = "sha256-KSVqjHlXl85JaqKiW5R86HCMdtFBwTMJkxFoySOcahs=";
  };

  vendorHash = "sha256-W8w66weYzCpZ+hmFyK2F6wdFz6aAZ9UxMhccNy1X1R8=";

=======
    rev = "affd7b21a5aa1b57f086e6871753cb98ce088d76";
    sha256 = "y1SWlBFgX3bFoSRGJ45DdC1DoIK5BfO9Vpi2h57wWtU=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Otherwise, will try to install a "scripts" binary; it's only used in
  # dockerize.sh, which we don't care about.
  subPackages = [ "." ];

<<<<<<< HEAD
=======
  vendorSha256 = "W8w66weYzCpZ+hmFyK2F6wdFz6aAZ9UxMhccNy1X1R8=";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Advanced Honeypot framework";
    homepage = "https://github.com/honeytrap/honeytrap";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
