{ stdenv, python2, fetchFromGitHub }:

with python2.pkgs; buildPythonApplication rec {
  pname = "isso";
  version = "0.12.2";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "posativ";
    repo = pname;
    rev = version;
    sha256 = "18v8lzwgl5hcbnawy50lfp3wnlc0rjhrnw9ja9260awkx7jra9ba";
  };

  propagatedBuildInputs = [
    bleach
    cffi
    configparser
    html5lib
    ipaddr
    jinja2
    misaka
    werkzeug
  ];

  checkInputs = [ nose ];

  checkPhase = ''
    ${python.interpreter} setup.py nosetests
  '';

  meta = with stdenv.lib; {
    description = "A commenting server similar to Disqus";
    homepage = https://posativ.org/isso/;
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}

