{
  buildPythonPackage,
  lib,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "webencodings";
  version = "0.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s2ocJF8tMEll604KgoSDeSQdwEuGWvzEqrFnSFh+GSM=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test webencodings/tests.py
  '';

  meta = {
    description = "Character encoding aliases for legacy web content";
    homepage = "https://github.com/SimonSapin/python-webencodings";
    license = lib.licenses.bsd3;
  };
}
