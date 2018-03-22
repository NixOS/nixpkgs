{ stdenv, fetchPypi, buildPythonApplication, lxml, typed-ast, psutil }:

buildPythonApplication rec {
  pname = "mypy";
  version = "0.570";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "09cz0h4d6xcdqlchw080nkjlwki3mgjrlvfnj5hxxwi3cgv9imw3";
  };

  propagatedBuildInputs = [ lxml typed-ast psutil ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
