{ lib
, fetchFromGitHub
, buildGoModule
, testers
, gh-dash
}:

buildGoModule rec {
  pname = "gh-dash";
<<<<<<< HEAD
  version = "3.11.0";
=======
  version = "3.7.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-dash";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XvNc68pVwqBLthkr3jb578Avpnr1NKT1XWUD4aazBHw=";
  };

  vendorHash = "sha256-COPEgRqogRkGuJm56n9Cqljr7H8QT0RSKAdnXbHm+nw=";
=======
    hash = "sha256-loAtRXns7plBeVOM+d/euyRS86MG+NRhGB4WpHT7KlM=";
  };

  vendorHash = "sha256-0ySTcQDM7Dole6ojnhr7vwUWOM4p6kFN69VqMP0jAY0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dlvhdr/gh-dash/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion { package = gh-dash; };
  };

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${src.rev}";
    description = "Github Cli extension to display a dashboard with pull requests and issues";
    homepage = "https://github.com/dlvhdr/gh-dash";
=======
    description = "gh extension to display a dashboard with pull requests and issues";
    homepage = "https://github.com/dlvhdr/gh-dash";
    changelog = "https://github.com/dlvhdr/gh-dash/releases/tag/${src.rev}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}
