{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knockpy";
  version = "5.1.0";
  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "guelfoweb";
    repo = "knock";
    rev = version;
    sha256 = "sha256-4W6/omGPmQFuZ/2AVNgCs2q0ti/P8OY4o7b4/g9q+Rc=";
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

  pythonImportsCheck = [ "knockpy" ];

  meta = with lib; {
    description = "Tool to scan subdomains";
    homepage = "https://github.com/guelfoweb/knock";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
