{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zabbix-utils";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zabbix";
    repo = "python-zabbix-utils";
    tag = "v${version}";
    hash = "sha256-/9OTehMGELU70Y3ZU1ZB4/ODkI3UbfIXNQ7H/vTz6JE=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zabbix_utils" ];

  meta = {
    description = "Library for zabbix";
    homepage = "https://github.com/zabbix/python-zabbix-utils";
    changelog = "https://github.com/zabbix/python-zabbix-utils/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
