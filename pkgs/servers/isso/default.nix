{ stdenv, python3Packages, fetchFromGitHub }:

with python3Packages; buildPythonApplication rec {

  pname = "isso";
  # Can not use 0.12.2 because of:
  # https://github.com/posativ/isso/issues/617
  version = "unstable-2020-09-14";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "posativ";
    repo = pname;
    rev = "f4d2705d4f1b51f444d0629355a6fcbcec8d57b5";
    sha256 = "02jgfzq3svd54zj09jj7lm2r7ypqqjynzxa9dgnnm0pqvq728wzr";
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

  meta = with stdenv.lib; {
    description = "A commenting server similar to Disqus";
    homepage = "https://posativ.org/isso/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}

