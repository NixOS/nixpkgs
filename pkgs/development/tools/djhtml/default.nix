{ lib
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
}:
buildPythonApplication rec {
  pname = "djhtml";
  version = "3.0.5";

  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rtts";
    repo = pname;
    rev = version;
    hash = "sha256-m13lw1x+URAYuDc0gXRIxfRnd6kQxeAuLDqYXeOgQE0=";
  };

  pythonImportsCheck = [ "djhtml" ];

  meta = with lib; {
    homepage = "https://github.com/rtts/djhtml";
    description = "Django/Jinja template indenter";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ thubrecht ];
  };
}
