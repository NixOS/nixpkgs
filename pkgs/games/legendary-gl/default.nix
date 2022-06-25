{ lib
, fetchFromGitHub
, buildPythonApplication
, pythonOlder
, requests
}:

buildPythonApplication rec {
  pname = "legendary-gl"; # Name in pypi
  version = "0.20.26";

  src = fetchFromGitHub {
    owner = "derrod";
    repo = "legendary";
    rev = "refs/tags/${version}";
    sha256 = "sha256-NqAdS5PN7Qj/HdZ2quemb0xJQsD3Ox1a/TVXj3QMq9c=";
  };

  propagatedBuildInputs = [ requests ];

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
}
