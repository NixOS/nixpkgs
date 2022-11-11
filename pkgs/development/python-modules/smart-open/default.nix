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
, paramiko
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "smart-open";
  version = "6.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "smart_open";
    rev = "v${version}";
    sha256 = "sha256-AtFIluoI2QeHUX2dclEmOxsv/cEtusWq7GyViRBhL5g=";
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
    paramiko
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
