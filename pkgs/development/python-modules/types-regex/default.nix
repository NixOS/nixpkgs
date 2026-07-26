{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-regex";
  version = "2026.7.10.20260711";
  pyproject = true;

  src = fetchPypi {
    pname = "types_regex";
    inherit (finalAttrs) version;
    hash = "sha256-mqGxQgYK3V1KT0IUbry3DgHnsniefORzJVMj88Xu3e0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "regex-stubs" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Typing stubs for regex";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dwoffinden ];
  };
})
