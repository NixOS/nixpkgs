{ stdenv, fetchPypi, buildPythonApplication, lxml, typed-ast, psutil }:

buildPythonApplication rec {
  pname = "mypy";
  version = "0.560";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jja0xlwqajxzab8sabiycax8060zikg89dnl9a7lkqcrwprl35x";
  };

  propagatedBuildInputs = [ lxml typed-ast psutil ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
