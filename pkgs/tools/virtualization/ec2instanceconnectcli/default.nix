{ lib, buildPythonPackage, fetchPypi, boto3, cryptography }:

buildPythonPackage rec {
  pname = "ec2instanceconnectcli";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VaCyCnEhSx1I3bNo57p0IXf92+tO1tT7KSUXzO1IyIU=";
  };

  propagatedBuildInputs = [ boto3 cryptography ];

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
