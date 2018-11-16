{ stdenv, python2, fetchFromGitHub }:

with python2.pkgs; buildPythonApplication rec {
  pname = "isso";
  version = "0.11.1";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "posativ";
    repo = pname;
    rev = version;
    sha256 = "0545vh0sb5i4cz9c0qgch77smpwgav3rhl1dxk9ij6rx4igjk03j";
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

