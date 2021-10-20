{ lib
, buildPythonPackage
, fetchPypi
, pytest
, boto3
, six
, pyyaml
, mock
}:

buildPythonPackage rec {
  pname = "serverlessrepo";
  version = "0.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "671f48038123f121437b717ed51f253a55775590f00fbab6fbc6a01f8d05c017";
  };

  propagatedBuildInputs = [
    six
    boto3
    pyyaml
  ];

  checkInputs = [ pytest mock ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-serverlessrepo-python";
    description = "Helpers for working with the AWS Serverless Application Repository";
    longDescription = ''
      A Python library with convenience helpers for working with the
      AWS Serverless Application Repository.
    '';
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ dhkl ];
  };
}
