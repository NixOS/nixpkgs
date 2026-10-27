{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  mock,
  sphinx-testing,
  sphinx,
  blockdiag,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-blockdiag";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qkm/kkUW9d6KR5mUx76B4HffVZnJ2ioIIAPVs4jh1FA=";
  };

  buildInputs = [
    mock
    sphinx-testing
  ];
  propagatedBuildInputs = [
    sphinx
    blockdiag
  ];

  # Seems to look for files in the wrong dir
  doCheck = false;

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx blockdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-blockdiag";
    maintainers = [ ];
    license = lib.licenses.bsd2;
  };
}
