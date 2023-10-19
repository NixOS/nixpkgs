{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "securetar";
  version = "2023.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-3bDboggvKbpWyjpUOrUmtJx3Nj/6Uvut2nEQLYJubDA=";
  };

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
