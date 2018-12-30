{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, boto3
, six
}:

buildPythonPackage rec {
  pname = "serverlessrepo";
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "384dc37394ffe1c8036f79a78b15bada4cb954a39f07bdf68f123c1a191fd0b2";
  };
  doCheck = false;

  propagatedBuildInputs = [
    pyyaml
    boto3
    six
  ];

  meta = with lib; {
    description = "A Python library with convenience helpers for working with the AWS Serverless Application Repository.";
    homepage = https://github.com/awslabs/aws-serverlessrepo-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ jnsaff ];
  };
}