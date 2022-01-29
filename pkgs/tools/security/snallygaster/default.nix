{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "snallygaster";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "hannob";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xUWnu+T6+5Ro6TrmtFD/Qd40FffY5rfuAvWzNkBhTME=";
  };

  propagatedBuildInputs = with python3Packages; [
    urllib3
    beautifulsoup4
    dnspython
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # we are not interested in linting the project
    "--ignore=tests/test_codingstyle.py"
  ];

  meta = with lib; {
    description = "Tool to scan for secret files on HTTP servers";
    homepage = "https://github.com/hannob/snallygaster";
    license = licenses.cc0;
    maintainers = with maintainers; [ hexa ];
  };
}
