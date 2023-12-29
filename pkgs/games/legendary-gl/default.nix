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
  version = "unstable-2023-10-14";

  src = fetchFromGitHub {
    owner = "derrod";
    repo = "legendary";
    rev = "450784283dd49152dda6322db2fb2ef33e7c382e";
    sha256 = "sha256-iwIaxD35tkOX6NX1SVNmN2OQACwaX/C4xnfgT5YcUvg=";
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
