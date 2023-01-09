{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knockpy";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "guelfoweb";
    repo = "knock";
    rev = "refs/tags/${version}";
    hash = "sha256-If8w6Z75nQsayJBqJs+D9++7kqCbkmwkszOaMATDTpY=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    colorama
    matplotlib
    networkx
    pyqt5
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "knockpy"
  ];

  meta = with lib; {
    description = "Tool to scan subdomains";
    homepage = "https://github.com/guelfoweb/knock";
    changelog = "https://github.com/guelfoweb/knock/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
