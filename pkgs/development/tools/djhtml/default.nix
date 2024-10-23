{ lib
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
}:
buildPythonApplication rec {
  pname = "djhtml";
  version = "3.0.7";

  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rtts";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-W93J3UFUrCqT718zoGcu96ORYFt0NLyYP7iVWbr8FYo=";
  };

  pythonImportsCheck = [ "djhtml" ];

  meta = with lib; {
    homepage = "https://github.com/rtts/djhtml";
    description = "Django/Jinja template indenter";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
