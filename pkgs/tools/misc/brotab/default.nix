{ lib, fetchFromGitHub, glibcLocales, python }:

python.pkgs.buildPythonApplication rec {
  version = "1.2.1";
  pname = "brotab";

  src = fetchFromGitHub {
    owner = "balta2ar";
    repo = pname;
    rev = version;
    sha256 = "14yz0szwzdjvwkw24rma34y6iiwnw9qzsm89gkglc0xxa6msg6j3";
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
