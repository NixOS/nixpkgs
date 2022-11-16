{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, sphinx
, mock
, repeated-test
, unittestCheckHook
, attrs
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "sigtools";
  version = "4.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-S44TWpzU0uoA2mcMCTNy105nK6OruH9MmNjnPepURFw=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
  ];

  checkInputs = [
    mock
    repeated-test
    sphinx
    unittestCheckHook
  ];

  meta = with lib; {
    description = "Utilities for working with 3.3's inspect.Signature objects.";
    homepage = "https://pypi.python.org/pypi/sigtools";
    license = licenses.mit;
  };

}
