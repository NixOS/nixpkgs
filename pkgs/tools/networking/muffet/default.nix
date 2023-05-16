{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "muffet";
<<<<<<< HEAD
  version = "2.9.2";
=======
  version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-M+yId2cNTO1n+E0UmMJK7aLmeDdXnI3McqTxL5EvB+A=";
  };

  vendorHash = "sha256-NTQlhLlSPh9+Il08T9I2qc+BqIo9RniOFG9Dgeez1QA=";
=======
    hash = "sha256-8+aOxrmLc0iM6uQ35Qtn+a8bzNS1zg1AM25hDylvAEQ=";
  };

  vendorHash = "sha256-BmaljudKwALbx8ECVOpXlEi+/3pOt6osRqHvn9Ek/MI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
