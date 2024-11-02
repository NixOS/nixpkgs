{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "4.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-38DJFe8Umd0GA5cPXBECxr1+t7asRkNLKabYQL8Cckg=";
  };

  # fails..
  doCheck = false;

  pythonImportsCheck = [ "zodbpickle" ];

  meta = with lib; {
    description = "Fork of Python's pickle module to work with ZODB";
    homepage = "https://github.com/zopefoundation/zodbpickle";
    changelog = "https://github.com/zopefoundation/zodbpickle/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
