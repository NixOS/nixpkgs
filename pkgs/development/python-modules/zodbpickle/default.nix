{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dcF5Kse9W89JUFggYqw2hOMiqhOrmEIOO/7EWCJzo2g=";
  };

  # fails..
  doCheck = false;

  pythonImportsCheck = [ "zodbpickle" ];

  meta = with lib; {
    description = "Fork of Python's pickle module to work with ZODB";
    homepage = "https://github.com/zopefoundation/zodbpickle";
    changelog = "https://github.com/zopefoundation/zodbpickle/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
