{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-webencodings";
  version = "0.6.0.20260907";
  pyproject = true;

  src = fetchPypi {
    pname = "types_webencodings";
    inherit (finalAttrs) version;
    hash = "sha256-76hbxRFEGe1FrsInylBRzKY/o+K9E/z3kBfuQQdgPvw=";
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
