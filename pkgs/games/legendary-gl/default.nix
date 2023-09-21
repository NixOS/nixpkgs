{ lib
, gitUpdater
, fetchFromGitHub
, buildPythonApplication
, pythonOlder
, requests
, filelock
}:

buildPythonApplication rec {
  pname = "legendary-gl"; # Name in pypi
  version = "0.20.33";

  src = fetchFromGitHub {
    owner = "derrod";
    repo = "legendary";
    rev = "refs/tags/${version}";
    sha256 = "sha256-fEQUChkxrKV2IkFGORUolZE2qTzA10Xxogjl5Va4TcE=";
  };

  propagatedBuildInputs = [
    requests
    filelock
  ];

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
