{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "toml";
  version = "0.10.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f";
  };

  build-system = [ setuptools ];

  # This package has a test script (built for Travis) that involves a)
  # looking in the home directory for a binary test runner and b) using
  # git to download a test suite.
  doCheck = false;

  meta = {
    description = "Python library for parsing and creating TOML";
    homepage = "https://github.com/uiri/toml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twey ];
  };
})
