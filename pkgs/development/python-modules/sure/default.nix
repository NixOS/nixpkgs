{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
  mock,
  six,
  isPyPy,
}:

buildPythonPackage rec {
  pname = "sure";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yPxvq8Dn9phO6ruUJUDkVkblvvC7mf5Z4C2mNOTUuco=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "rednose = 1" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    mock
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    mock
  ];

  disabledTestPaths = [
    "tests/test_old_api.py" # require nose
  ];

  disabledTests = lib.optionals (isPyPy) [
    # test extension of 'dict' object is broken
    "test_should_compare_dict_with_non_orderable_key_types"
    "test_should_compare_dict_with_enum_keys"
  ];

  pythonImportsCheck = [ "sure" ];

  meta = {
    description = "Utility belt for automated testing";
    mainProgram = "sure";
    homepage = "https://sure.readthedocs.io/";
    changelog = "https://github.com/gabrielfalcao/sure/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
