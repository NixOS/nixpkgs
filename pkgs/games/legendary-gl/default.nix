{ lib
, gitUpdater
, fetchFromGitHub
, buildPythonApplication
, pythonOlder
, requests
<<<<<<< HEAD
, filelock
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonApplication rec {
  pname = "legendary-gl"; # Name in pypi
<<<<<<< HEAD
  version = "0.20.33";
=======
  version = "0.20.32";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "derrod";
    repo = "legendary";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    sha256 = "sha256-fEQUChkxrKV2IkFGORUolZE2qTzA10Xxogjl5Va4TcE=";
  };

  propagatedBuildInputs = [
    requests
    filelock
  ];
=======
    sha256 = "sha256-MsvhVS3lqhgBJ+S/cjXFP70I3rM5WBYT7TyVlRWhNWw=";
  };

  propagatedBuildInputs = [ requests ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "legendary" ];

  meta = with lib; {
    description = "A free and open-source Epic Games Launcher alternative";
    homepage = "https://github.com/derrod/legendary";
    license = licenses.gpl3;
    maintainers = with maintainers; [ equirosa ];
  };

  passthru.updateScript = gitUpdater { };
}
