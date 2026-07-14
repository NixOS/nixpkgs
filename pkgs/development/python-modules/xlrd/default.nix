{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "xlrd";
  version = "2.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-CLXiXeWPIc5x3H2zs7gQbB+ndvMCTFTkW0WzdOiSNMk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "xlrd" ];

  meta = {
    homepage = "https://www.python-excel.org/";
    description = "Library for developers to extract data from Microsoft Excel (tm) spreadsheet files";
    mainProgram = "runxlrd.py";
    license = lib.licenses.bsd0;
  };
})
