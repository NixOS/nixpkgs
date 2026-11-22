{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-webencodings";
  version = "0.6.0.20261104";
  pyproject = true;

  src = fetchPypi {
    pname = "types_webencodings";
    inherit (finalAttrs) version;
    hash = "sha256-MCHX6nARpKUaQ7LcTA5IVsjZsbsaGj0lAKsXciQiWwg=";
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
