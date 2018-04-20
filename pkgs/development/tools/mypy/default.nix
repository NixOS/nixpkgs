{ stdenv, fetchPypi, buildPythonApplication, lxml, typed-ast, psutil }:

buildPythonApplication rec {
  pname = "mypy";
  version = "0.590";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ynyrrj0wjyw130ay9x1ca88lbhbblp06bfsjrpzbcvp4grgxgq4";
  };

  propagatedBuildInputs = [ lxml typed-ast psutil ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
