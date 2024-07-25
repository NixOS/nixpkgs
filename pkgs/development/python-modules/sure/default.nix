{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  mock,
  six,
  isPyPy,
}:

buildPythonPackage rec {
  pname = "sure";
  version = "2.0.1";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yPxvq8Dn9phO6ruUJUDkVkblvvC7mf5Z4C2mNOTUuco=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "rednose = 1" "" \
      --replace-fail "--cov=sure" ""
  '';

  propagatedBuildInputs = [
    mock
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_old_api.py" # require nose
  ];

  pythonImportsCheck = [ "sure" ];

  meta = with lib; {
    description = "Utility belt for automated testing";
    mainProgram = "sure";
    homepage = "https://sure.readthedocs.io/";
    changelog = "https://github.com/gabrielfalcao/sure/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
