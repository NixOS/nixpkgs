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
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xf0g97jym4607kikkiassrnmcfniz5syaigxlz09d9p8h70sd0c";
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

  postPatch = ''
    substituteInPlace setup.py --replace "pyyaml~=3.12" "pyyaml~=5.1"
  '';

  meta = with lib; {
    homepage = https://github.com/awslabs/aws-serverlessrepo-python;
    description = "Helpers for working with the AWS Serverless Application Repository";
    longDescription = ''
      A Python library with convenience helpers for working with the
      AWS Serverless Application Repository.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ dhkl ];
  };
}
