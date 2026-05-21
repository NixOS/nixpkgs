{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "unittest-data-provider";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "1gn2ka4vqpayx4cpbp8712agqjh3wdpk9smdxnp709ccc2v7zg46";
  };

  build-system = [ setuptools ];

  meta = {
    description = "PHPUnit-like @dataprovider decorator for unittest";
    homepage = "https://github.com/yourlabs/unittest-data-provider";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
