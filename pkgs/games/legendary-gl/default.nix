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
  version = "0.20.34";

  src = fetchFromGitHub {
    owner = "derrod";
    repo = "legendary";
    rev = "56d439ed2d3d9f34e2b08fa23e627c23a487b8d6";
    sha256 = "sha256-yCHeeEGw+9gtRMGyIhbStxJhmSM/1Fqly7HSRDkZILQ=";
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
