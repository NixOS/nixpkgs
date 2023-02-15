{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "securetar";
  version = "2022.02.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = pname;
    rev = version;
    hash = "sha256-FwQp08jwcGh07zpHqRNoUUmeLZJh78wI8wCXySi3Tdc=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
