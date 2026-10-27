{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-appdirs";
  version = "1.4.3.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-gyaNpkWFNhv6KR+PUGogknYhKgSXvTfwUSqTmz1p/xQ=";
  };

  build-system = [ setuptools ];

  meta = {
    description = "PEP 561 type stub package for the appdirs package";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
