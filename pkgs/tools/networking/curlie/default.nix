{ buildGoModule, fetchFromGitHub, lib, curlie, testers }:

buildGoModule rec {
  pname = "curlie";
<<<<<<< HEAD
  version = "1.7.1";
=======
  version = "1.6.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-EHSFr05VXJuOjUnweEJngdnfSUZUF1HsO28ZBSLGlvE=";
=======
    hash = "sha256-3EKxuEpFm+lp2myMfymYYY9boSXGOF2iAdjtGKnjJK0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./bump-golang-x-sys.patch
  ];

<<<<<<< HEAD
  vendorHash = "sha256-VsPdMUfS4UVem6uJgFISfFHQEKtIumDQktHQFPC1muc=";
=======
  vendorSha256 = "sha256-VsPdMUfS4UVem6uJgFISfFHQEKtIumDQktHQFPC1muc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = curlie;
    command = "curlie version";
  };

  meta = with lib; {
    description = "Frontend to curl that adds the ease of use of httpie, without compromising on features and performance";
    homepage = "https://curlie.io/";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.mit;
  };
}
