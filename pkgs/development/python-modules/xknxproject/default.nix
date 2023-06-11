{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyzipper
, setuptools
}:

buildPythonPackage rec {
  pname = "xknxproject";
  version = "3.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "xknxproject";
    rev = "refs/tags/${version}";
    hash = "sha256-4FZJsw/x7yYPyAc26YTMWMzJuSGC3fkh3PunfUXmEUw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    pyzipper
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
