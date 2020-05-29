{ lib
, fetchFromGitHub
, buildPythonApplication
, pythonOlder
, requests
}:

buildPythonApplication rec {
  pname = "legendary-gl"; # Name in pypi
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "derrod";
    repo = "legendary";
    rev = version;
    sha256 = "05r88qi8mmbj07wxcpb3fhbl40qscbq1aqb0mnj9bpmi9gf5zll5";
  };

  propagatedBuildInputs = [ requests ];

  disabled = pythonOlder "3.8";

  meta = with lib; {
    description = "A free and open-source Epic Games Launcher alternative";
    homepage = "https://github.com/derrod/legendary";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wchresta ];
  };
}

