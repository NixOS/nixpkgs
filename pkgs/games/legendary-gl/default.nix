{ lib
, fetchFromGitHub
, buildPythonApplication
, pythonOlder
, requests
}:

buildPythonApplication rec {
  pname = "legendary-gl"; # Name in pypi
  version = "0.20.25";

  src = fetchFromGitHub {
    owner = "derrod";
    repo = "legendary";
    rev = version;
    sha256 = "07z5ffi7lnvs64pksy30fbfv2i11dkkycyh31vyc4y7fsn1vd0vf";
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
