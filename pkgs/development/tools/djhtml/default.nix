{ lib
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
}:
buildPythonApplication rec {
  pname = "djhtml";
  version = "3.0.6";

  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rtts";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-3bviLyTLpHcAUWAaAmNZukWBDwFs8yFOAxl2bSk9GNY=";
  };

  pythonImportsCheck = [ "djhtml" ];

  meta = with lib; {
    homepage = "https://github.com/rtts/djhtml";
    description = "Django/Jinja template indenter";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
