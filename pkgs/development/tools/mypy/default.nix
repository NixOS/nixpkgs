{ stdenv, fetchPypi, buildPythonApplication, lxml, typed-ast }:

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "mypy";
  version = "0.521";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d30df20cd937b80cfc6007d75426f27a232789cfa288c63bf9370f2542c9658";
  };

  propagatedBuildInputs = [ lxml typed-ast ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
