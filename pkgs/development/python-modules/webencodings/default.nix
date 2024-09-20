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
    sha256 = "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923";
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
