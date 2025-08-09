{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyserial-asyncio-fast,
  pytestCheckHook,
  pythonOlder,
  pytz,
}:

buildPythonPackage rec {
  pname = "upb-lib";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "gwww";
    repo = "upb-lib";
    tag = version;
    hash = "sha256-tjmsg8t2/WEjnRHyqN2lxsAgfISV1uAnhmq2dXAG15A=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pyserial-asyncio-fast
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "upb_lib" ];

  meta = {
    description = "Library for interacting with UPB PIM";
    homepage = "https://github.com/gwww/upb-lib";
    changelog = "https://github.com/gwww/upb-lib/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
