{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knockpy";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "guelfoweb";
    repo = "knock";
    rev = version;
    hash = "sha256-QPOIpgJt+09zRvSavRxuVEN+GGk4Z1CYCXti37YaO7o=";
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
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
