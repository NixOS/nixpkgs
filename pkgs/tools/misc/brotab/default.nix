{ lib, fetchFromGitHub, glibcLocales, python }:

python.pkgs.buildPythonApplication rec {
  version = "1.2.2";
  pname = "brotab";

  src = fetchFromGitHub {
    owner = "balta2ar";
    repo = pname;
    rev = version;
    sha256 = "1c6npyws705qf9rv70mmh7d0almmpxz87a0n65lhw08lms1h3dl2";
  };

  propagatedBuildInputs = with python.pkgs; [
    requests
    flask
    psutil
    setuptools
  ];

  checkBuildInputs = with python.pkgs; [
    pytest
  ];

  # test_integration.py requires Chrome browser session
  checkPhase = ''
    ${python.interpreter} -m unittest brotab/tests/test_{brotab,utils}.py
  '';

  meta = with lib; {
    homepage = "https://github.com/balta2ar/brotab";
    description = "Control your browser's tabs from the command line";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
