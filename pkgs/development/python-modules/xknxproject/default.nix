{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyzipper
, setuptools
, striprtf
, wheel
}:

buildPythonPackage rec {
  pname = "xknxproject";
  version = "3.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "xknxproject";
    rev = "refs/tags/${version}";
    hash = "sha256-0tnmD5X2wskyX9AKhn3JKwzZFpkKy5cKaGnzkUyjWhk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    cryptography
    pyzipper
    striprtf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xknxproject"
  ];

  meta = with lib; {
    description = "ETS project parser";
    homepage = "https://github.com/XKNX/xknxproject";
    changelog = "https://github.com/XKNX/xknxproject/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
