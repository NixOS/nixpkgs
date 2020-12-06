{ lib
, fetchFromGitHub
, buildPythonApplication
, pythonOlder
, requests
}:

buildPythonApplication rec {
  pname = "legendary-gl"; # Name in pypi
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "derrod";
    repo = "legendary";
    rev = version;
    sha256 = "0kdrhdvh9gxq1zinh5w852f5fjls9902pcrkhkhm2c0vvq7jfass";
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
