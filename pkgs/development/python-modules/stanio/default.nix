{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  numpy,
}:

buildPythonPackage rec {
  pname = "stanio";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3uQpMU2WXzkBga+o/3/4FERG7rWMwlR8zBCLpz5nROI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "stanio" ];

  meta = with lib; {
    description = "Preparing inputs to and reading outputs from Stan";
    homepage = "https://github.com/WardBrian/stanio";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wegank ];
  };
}
