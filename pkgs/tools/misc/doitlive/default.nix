{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "doitlive";
  version = "4.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0yabw2gqsjdivivlwsc2q7p3qq72cccx3xzfc1a4gd8d74f84nrw";
  };

  propagatedBuildInputs = with python3Packages; [ click click-completion click-didyoumean ];

  # disable tests (too many failures)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tool for live presentations in the terminal";
    homepage = https://pypi.python.org/pypi/doitlive;
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
