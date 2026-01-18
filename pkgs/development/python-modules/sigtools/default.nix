{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  mock,
  repeated-test,
  setuptools-scm,
  sphinx,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "sigtools";
  version = "4.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S44TWpzU0uoA2mcMCTNy105nK6OruH9MmNjnPepURFw=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ attrs ];

  nativeCheckInputs = [
    mock
    repeated-test
    sphinx
    unittestCheckHook
  ];

  pythonImportsCheck = [ "sigtools" ];

  meta = {
    description = "Utilities for working with inspect.Signature objects";
    homepage = "https://sigtools.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
