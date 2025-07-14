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
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zabbix";
    repo = "python-zabbix-utils";
    rev = "refs/tags/v${version}";
    hash = "sha256-rRPen/FzWT0cCnXWiSdoybtXeP1pxYqnjq5b0QPVs1I=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zabbix_utils" ];

  meta = {
    description = "Library for zabbix";
    homepage = "https://github.com/zabbix/python-zabbix-utils";
    changelog = "https://github.com/zabbix/python-zabbix-utils/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
