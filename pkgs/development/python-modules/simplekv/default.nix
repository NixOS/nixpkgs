{
  lib,
  buildPythonPackage,
  dulwich,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "simplekv";
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "simplekv";
    rev = "refs/tags/${version}";
    hash = "sha256-seUGDj2q84+AjDFM1pxMLlHbe9uBgEhmqA96UHjnCmo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dulwich
    mock
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "simplekv" ];

  disabledTests = [
    # Issue with fixture
    "test_concurrent_mkdir"
  ];

  meta = with lib; {
    description = "Simple key-value store for binary data";
    homepage = "https://github.com/mbr/simplekv";
    changelog = "https://github.com/mbr/simplekv/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
