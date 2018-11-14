{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "doitlive";
  version = "4.1.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0zkvmnv6adz0gyqiql8anpxnh8zzpqk0p2n0pf2kxy55010qs4wz";
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
