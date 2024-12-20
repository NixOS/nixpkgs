{
  buildPythonPackage,
  fetchPypi,
  lib,
  hypothesis,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "senf";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kFlFEOqYVBM47YWmwUOPuiCqoqSW+I3y0tNlSFZjjNE=";
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # Both don't work even with HOME specified...
    "test_getuserdir"
    "test_expanduser_user"
  ];

  pythonImportsCheck = [ "senf" ];

  meta = with lib; {
    description = "Consistent filename handling for all Python versions and platforms";
    homepage = "https://senf.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ cab404 ];
  };

}
