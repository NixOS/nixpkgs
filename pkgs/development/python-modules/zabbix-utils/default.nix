{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "zabbix-utils";
<<<<<<< HEAD
  version = "2.0.4";
  pyproject = true;

=======
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "zabbix";
    repo = "python-zabbix-utils";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/9OTehMGELU70Y3ZU1ZB4/ODkI3UbfIXNQ7H/vTz6JE=";
=======
    hash = "sha256-VEL7vAIodxFdw3XEjL0nSQL49RiaxfZdS+HcYUzxgho=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
