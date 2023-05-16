{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "time-decode";
<<<<<<< HEAD
  version = "6.1.0";
=======
  version = "4.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "digitalsleuth";
    repo = "time_decode";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-LbXycu3Yiku9ToW+WS/yUqwicvckj2IkP09TiZkRXnk=";
=======
    hash = "sha256-6OSa8tOTAzQbi5aYPDJotWApeh8E3wi4V7RN16Go/E4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    python-dateutil
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "time_decode"
  ];

  meta = with lib; {
    description = "Timestamp and date decoder";
    homepage = "https://github.com/digitalsleuth/time_decode";
    changelog = "https://github.com/digitalsleuth/time_decode/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
