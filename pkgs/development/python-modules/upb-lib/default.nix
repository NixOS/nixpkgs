{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial-asyncio-fast,
  pytestCheckHook,
  pythonOlder,
  pytz,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "upb-lib";
  version = "0.5.7";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "gwww";
    repo = "upb-lib";
    rev = "refs/tags/${version}";
    hash = "sha256-y06/XqdmGXTd2Qhr2iXnmIKCSpAetXwI1UXv555ewoc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pyserial-asyncio-fast
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "upb_lib" ];

  disabledTests = [
    # AssertionError
    "test_create_control_word_all"
  ];

  meta = with lib; {
    description = "Library for interacting with UPB PIM";
    homepage = "https://github.com/gwww/upb-lib";
    changelog = "https://github.com/gwww/upb-lib/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
