{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
}:

buildPythonPackage rec {
  pname = "stanio";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NI1S+UfexDHhGPS2AcTFKWkpuGQB1NTdWqk3Ow1K5Kw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "stanio" ];

  meta = {
    description = "Preparing inputs to and reading outputs from Stan";
    homepage = "https://github.com/WardBrian/stanio";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
