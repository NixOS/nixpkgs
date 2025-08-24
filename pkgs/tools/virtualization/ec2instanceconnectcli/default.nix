{
  lib,
  buildPythonPackage,
  fetchPypi,
  boto3,
  cryptography,
}:

buildPythonPackage rec {
  pname = "ec2instanceconnectcli";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/U59a6od0JI27VHX+Bvue/7tQy+iwU+g8yt9/GgdoH4=";
  };

  propagatedBuildInputs = [
    boto3
    cryptography
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "ec2instanceconnectcli" ];

  meta = with lib; {
    description = "Command Line Interface for AWS EC2 Instance Connect";
    homepage = "https://github.com/aws/aws-ec2-instance-connect-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
