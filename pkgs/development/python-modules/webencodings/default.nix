{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "webencodings";
  version = "0.5.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-s2ocJF8tMEll604KgoSDeSQdwEuGWvzEqrFnSFh+GSM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test webencodings/tests.py
  '';

  pythonImportsCheck = [ "webencodings" ];

  meta = {
    description = "Character encoding aliases for legacy web content";
    homepage = "https://github.com/gsnedders/python-webencodings";
    license = lib.licenses.bsd3;
  };
})
