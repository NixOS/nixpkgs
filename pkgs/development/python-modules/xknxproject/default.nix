{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyzipper,
  setuptools,
  striprtf,
}:

buildPythonPackage rec {
  pname = "xknxproject";
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "xknxproject";
    tag = version;
    hash = "sha256-IA6rEH7iv5IbmfAvNpuLXQQKdatTOzPXf+PwToBtlcg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyzipper
    striprtf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xknxproject" ];

  meta = {
    description = "Library to extract KNX projects and parses the underlying XML";
    homepage = "https://github.com/XKNX/xknxproject";
    changelog = "https://github.com/XKNX/xknxproject/releases/tag/${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
