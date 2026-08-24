{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-webencodings";
  version = "0.6.0.20260824";
  pyproject = true;

  src = fetchPypi {
    pname = "types_webencodings";
    inherit (finalAttrs) version;
    hash = "sha256-E8RE/Griw5IMIovuRKjk1FdIXcTUNS0NeDgWoSmyz9U=";
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
