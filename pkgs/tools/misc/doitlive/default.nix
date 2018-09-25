{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "doitlive";
  version = "4.0.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1icnjkczy52i3cp1fmsijqny571fz1h4b3wpdzz79cn90fr326pc";
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
