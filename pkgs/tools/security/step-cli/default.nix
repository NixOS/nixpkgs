{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "step-cli";
<<<<<<< HEAD
  version = "0.24.4";
=======
  version = "0.24.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-QSV1+EKaz0anV+Kj5sUEJgVEZkSi4cQG5GiWsgGKN/I=";
=======
    hash = "sha256-Qo0Bct2Eys6RHv17j1owUDVPoL+OcMJRpO8LP8P/cPw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${version}"
  ];

  preCheck = ''
    # Tries to connect to smallstep.com
    rm command/certificate/remote_test.go
  '';

<<<<<<< HEAD
  vendorHash = "sha256-R2lnbHTIfgKdgeZ21JLKlVuPIwvNmjXSlzb8bwrva2U=";
=======
  vendorHash = "sha256-uUD4CNFmj/0OjsvirVihMd9I94W0NYTR0WbqujrWUyw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
    homepage = "https://smallstep.com/cli/";
    changelog = "https://github.com/smallstep/cli/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "step";
  };
}
