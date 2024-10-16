{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pillow,
  requests,
  urwid,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "term-image";
  version = "0.7.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AnonymouX47";
    repo = "term-image";
    rev = "refs/tags/v${version}";
    hash = "sha256-uA04KHKLXW0lx1y5brpCDARLac4/C8VmVinVMkEtTdM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    pillow
  ];

  optional-dependencies = {
    urwid = [ urwid ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ optional-dependencies.urwid;

  disabledTestPaths = [
    # test_url needs online access
    "tests/test_image/test_url.py"
  ];

  pythonImportsCheck = [ "term_image" ];

  meta = with lib; {
    description = "Display images in the terminal with python";
    homepage = "https://github.com/AnonymouX47/term-image";
    changelog = "https://github.com/AnonymouX47/term-image/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ liff ];
  };
}
