{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-ipaddress";
  version = "1.0.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "types-ipaddress";
    inherit (finalAttrs) version;
    hash = "sha256-oD3zvlk15QugP6hD2qv/U5oEGijnPg/OLFcFvuVNOEE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ipaddress-python2-stubs" ];

  meta = {
    description = "Typing stubs for ipaddress";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
})
