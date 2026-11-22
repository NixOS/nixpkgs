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
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zabbix";
    repo = "python-zabbix-utils";
    tag = "v${version}";
    hash = "sha256-B63WtgUMamSVtDJ5TI0uDZgQ3GJTouM3Jnqzg55zn8I=";
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
