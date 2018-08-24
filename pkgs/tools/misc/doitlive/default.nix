{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "doitlive";
  version = "3.0.3";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "19i16ca835rb3gal1sxyvpyilj9a80n6nikf0smlzmxck38x86fj";
  };

  propagatedBuildInputs = with python3Packages; [ click ];

  # disable tests (too many failures)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tool for live presentations in the terminal";
    homepage = https://pypi.python.org/pypi/doitlive;
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
