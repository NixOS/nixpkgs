{ lib, python3Packages, fetchFromGitHub }:

with python3Packages; buildPythonApplication rec {

  pname = "isso";
  version = "0.12.4";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "posativ";
    repo = pname;
    rev = version;
    sha256 = "16wjpz8r74fzjvzhl6by3sjc2g1riz8lh59ccgp14bns1yhsh2yi";
  };

  propagatedBuildInputs = [
    itsdangerous
    jinja2
    misaka
    html5lib
    werkzeug
    bleach
    flask-caching
  ];

  buildInputs = [
    cffi
  ];

  checkInputs = [ nose ];

  checkPhase = ''
    ${python.interpreter} setup.py nosetests
  '';

  meta = with lib; {
    description = "A commenting server similar to Disqus";
    homepage = "https://posativ.org/isso/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}

