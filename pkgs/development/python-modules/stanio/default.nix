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
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NI1S+UfexDHhGPS2AcTFKWkpuGQB1NTdWqk3Ow1K5Kw=";
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
