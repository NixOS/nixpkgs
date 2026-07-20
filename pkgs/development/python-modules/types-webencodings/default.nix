{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-webencodings";
  version = "0.5.0.20260408";
  pyproject = true;

  src = fetchPypi {
    pname = "types_webencodings";
    inherit (finalAttrs) version;
    hash = "sha256-KMWWYZ82fkPu45PYX2Po0v22h0xlSo1EHDf4r+KcbQ0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "webencodings-stubs" ];

  meta = {
    description = "Typing stubs for webencodings";
    homepage = "https://pypi.org/project/types-webencodings/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
