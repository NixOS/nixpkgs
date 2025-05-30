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
  version = "3.8.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "xknxproject";
    tag = version;
    hash = "sha256-EIonCsolfAAFQpHuSFUuYAAZozjtqSwJCpw86Cc2d4I=";
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
