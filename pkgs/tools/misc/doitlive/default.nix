{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "doitlive";
  version = "4.2.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0sffr78h0hdrlpamg6v0iw2cgrkv7wy82mvrbzri0w1jqd29s526";
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
