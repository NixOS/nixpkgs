{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "oh";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "michaelmacinnis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DMxC5fv5ZLDv7gMajC/eyJd2YpO+OXFdvwAPYotnczw=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-f4rqXOu6yXUzNsseSaV9pb8c2KXItYOalB5pfH3Acnc=";
=======
  vendorSha256 = "sha256-f4rqXOu6yXUzNsseSaV9pb8c2KXItYOalB5pfH3Acnc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/michaelmacinnis/oh";
    description = "A new Unix shell";
    license = licenses.mit;
  };

  passthru = {
    shellPath = "/bin/oh";
  };
}
