{ stdenv, fetchPypi, buildPythonApplication, lxml, typed-ast, psutil }:

buildPythonApplication rec {
  pname = "mypy";
  version = "0.580";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ng3j3nmsklrg8middvc9ycvv87hx5dxh4b96s9pc3w1d49mmn9v";
  };

  propagatedBuildInputs = [ lxml typed-ast psutil ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
