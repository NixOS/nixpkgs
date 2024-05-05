{ lib
, buildPythonPackage
, fetchPypi
, unittestCheckHook
, mock
, sphinx-testing
, sphinx
, ditaa
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-ditaa";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57f2e13b059b38fde89580beca916ac6ca7456b2d706c3ddea9dd4890e5f5bd3";
  };

  buildInputs = [ mock sphinx-testing ];
  propagatedBuildInputs = [ sphinx ditaa ];

  # no tests provided
  doCheck = false;

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "tests" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx ditaa extension";
    homepage = "https://pypi.org/project/sphinxcontrib-ditaa";
    maintainers = with maintainers; [ ];
    license = licenses.bsd0;
  };

}
