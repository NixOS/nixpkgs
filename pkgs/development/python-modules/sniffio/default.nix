{
  lib,
  buildPythonPackage,
  curio,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "sniffio";
  version = "1.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9DJO3GcKD0l1CoG4lfNcOtuEPMpG8FMPefwbq7I3idw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    curio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sniffio" ];

  meta = {
    description = "Sniff out which async library your code is running under";
    homepage = "https://github.com/python-trio/sniffio";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
