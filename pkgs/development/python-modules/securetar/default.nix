{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "securetar";
  version = "2023.12.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = "securetar";
    rev = "refs/tags/${version}";
    hash = "sha256-P8aq1RRlEmXhJ4n0TSLVjYx4dvkckuz2aDGkAvp7bfo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "securetar"
  ];

  meta = with lib; {
    description = "Module to handle tarfile backups";
    homepage = "https://github.com/pvizeli/securetar";
    changelog = "https://github.com/pvizeli/securetar/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
