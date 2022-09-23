{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, azure-common
, azure-core
, azure-storage-blob
, boto3
, google-cloud-storage
, requests
, moto
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "smart-open";
  version = "6.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "smart_open";
    rev = "v${version}";
    sha256 = "sha256-FEIJ1DBW0mz7n+J03C1Lg8uAs2ZxI0giM7+mvuNPyGg=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    azure-storage-blob
    boto3
    google-cloud-storage
    requests
  ];

  checkInputs = [
    moto
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "smart_open"
  ];

  pythonImportsCheck = [
    "smart_open"
  ];

  meta = with lib; {
    description = "Library for efficient streaming of very large file";
    homepage = "https://github.com/RaRe-Technologies/smart_open";
    license = licenses.mit;
    maintainers = with maintainers; [ jyp ];
  };
}
