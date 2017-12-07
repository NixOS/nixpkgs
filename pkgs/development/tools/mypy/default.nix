{ stdenv, fetchPypi, buildPythonApplication, lxml, typed-ast }:

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "mypy";
  version = "0.540";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d82f51e228a88e5de6ac1d6699dd09e250ce7de217a5ff1256e317266e738ec";
  };

  propagatedBuildInputs = [ lxml typed-ast ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
