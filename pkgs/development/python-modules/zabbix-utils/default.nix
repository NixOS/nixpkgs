{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zabbix-utils";
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zabbix";
    repo = "python-zabbix-utils";
    tag = "v${version}";
    hash = "sha256-VEL7vAIodxFdw3XEjL0nSQL49RiaxfZdS+HcYUzxgho=";
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
