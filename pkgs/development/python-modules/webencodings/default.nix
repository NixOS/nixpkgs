{
  buildPythonPackage,
  lib,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "webencodings";
  version = "0.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Vl+a0DHHAtrkBOJ6CZ4+CRhqOrG5Ug8G0hVQK2Uf2RA=";
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
