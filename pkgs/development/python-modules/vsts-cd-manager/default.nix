{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  mock,
}:

buildPythonPackage rec {
  version = "1.0.2";
  format = "setuptools";
  pname = "vsts-cd-manager";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C7CQWc1VPhwgbpLvMkyw3PkjNIRtZGxExoT2JWuGRHs=";
  };

  propagatedBuildInputs = [
    msrest
    mock
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "vsts_cd_manager" ];

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
