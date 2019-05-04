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
  version = "0.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "533389d41a51450e50cc01405ab766550170149c08e1c85b3a1559b0fab4cb25";
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
    homepage = https://github.com/awslabs/aws-serverlessrepo-python;
    description = "Helpers for working with the AWS Serverless Application Repository";
    longDescription = ''
      A Python library with convenience helpers for working with the
      AWS Serverless Application Repository.
    '';
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ dhkl ];
  };
}
