{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "doitlive";
  version = "4.3.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "03qrs032x206xrl0x3z0fpvxgjivzz9rkmb11bqlk1id10707cac";
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
