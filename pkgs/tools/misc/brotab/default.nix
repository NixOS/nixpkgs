{ lib, fetchFromGitHub, glibcLocales, python }:

python.pkgs.buildPythonApplication rec {
  version = "1.1.0";
  pname = "brotab";

  src = fetchFromGitHub {
    owner = "balta2ar";
    repo = pname;
    rev = version;
    sha256 = "17yj5i8p28a7zmixdfa1i4gfc7c2fmdkxlymazasar58dz8m68mw";
  };

  propagatedBuildInputs = with python.pkgs; [
    requests
    flask
    requests
    pytest
    psutil
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
