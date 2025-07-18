{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zammad-py";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joeirimpan";
    repo = "zammad_py";
    tag = "v${version}";
    hash = "sha256-gU5OA5m8X03GM7ImXZZVLkEyoAXRCoFskfop8oXJFH0=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # requires a local zammad instance
    "test_users"
    "test_tickets"
    "test_groups"
    "test_pagination"
  ];

  pythonImportsCheck = [
    "zammad_py"
  ];

  meta = {
    changelog = "https://github.com/joeirimpan/zammad_py/blob/${src.tag}/HISTORY.rst";
    description = "Python API client for accessing zammad REST API";
    homepage = "https://github.com/joeirimpan/zammad_py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
