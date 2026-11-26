{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "dbglib";
  version = "0.3.0";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e0/VxJSa9DWnq1WPh7QGrNXd+dx/Afw7PpnrzsmkZ0w=";
  };
  propagatedBuildInputs = [ poetry-core ];
  pythonImportsCheck = [ "dbglib" ];
  meta = {
    homepage = "https://github.com/savioxavier/dbglib/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jetpackjackson ];
  };
}
