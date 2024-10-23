{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  pyzipper,
  setuptools,
  striprtf,
}:

buildPythonPackage rec {
  pname = "xknxproject";
  version = "3.8.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "xknxproject";
    rev = "refs/tags/${version}";
    hash = "sha256-iuW83gKDJTgFkfSW32OPOuwyGLyFoZGKQGUDJkVUGAM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyzipper
    striprtf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xknxproject" ];

  meta = with lib; {
    description = "Library to extract KNX projects and parses the underlying XML";
    homepage = "https://github.com/XKNX/xknxproject";
    changelog = "https://github.com/XKNX/xknxproject/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
