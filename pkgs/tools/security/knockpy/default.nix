{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knockpy";
  version = "6.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "guelfoweb";
    repo = "knock";
    rev = "refs/tags/${version}";
    hash = "sha256-O4tXq4pDzuTBEGAls2I9bfBRdHssF4rFBec4OtfUx6A=";
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
