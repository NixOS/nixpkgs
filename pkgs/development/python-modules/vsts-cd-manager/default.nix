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
    sha256 = "0ys4hrmjbxl4qr26qr3dhhs27yfwn1635vwjdqh1qgjmrmcr1c0b";
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
    maintainers = [ ];
  };
}
