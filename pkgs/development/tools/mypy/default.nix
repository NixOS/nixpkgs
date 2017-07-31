{ stdenv, fetchPypi, buildPythonApplication, lxml, typed-ast }:

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "mypy";
  version = "0.511";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vmfyi6zh49mi7rmns5hjgpqshq7islxwsgp80j1izf82r8xgx1z";
  };

  propagatedBuildInputs = [ lxml typed-ast ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
