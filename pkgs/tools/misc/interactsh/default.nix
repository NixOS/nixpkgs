{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "interactsh";
<<<<<<< HEAD
  version = "1.1.6";
=======
  version = "1.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-cSqDiJEJdtHwL/xumZPOp1JHg7SUZ/47nKFv4bWBo5U=";
  };

  vendorHash = "sha256-xtV+QLheWU6RJSjmoOunrsOfUhNCDWJORQDBAmJd2Io=";
=======
    hash = "sha256-hoh7Nug0XLu/8SPb+YY/TeaRqBIaq3dUAC+8iJ1wvpI=";
  };

  vendorHash = "sha256-B7DE2OEP0VikLfS6btILpdJ6rqwuoD2w7SqNnWD4Bdk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  modRoot = ".";
  subPackages = [
    "cmd/interactsh-client"
    "cmd/interactsh-server"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  meta = with lib; {
    description = "An Out of bounds interaction gathering server and client library";
    longDescription = ''
      Interactsh is an Open-Source Solution for Out of band Data Extraction,
      A tool designed to detect bugs that cause external interactions,
      For example - Blind SQLi, Blind CMDi, SSRF, etc.
    '';
    homepage = "https://github.com/projectdiscovery/interactsh";
    changelog = "https://github.com/projectdiscovery/interactsh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hanemile ];
  };
}
