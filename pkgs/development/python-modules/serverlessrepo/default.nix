{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  boto3,
  six,
  pyyaml,
  mock,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "serverlessrepo";
  version = "0.1.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "671f48038123f121437b717ed51f253a55775590f00fbab6fbc6a01f8d05c017";
  };

  propagatedBuildInputs = [
    six
    boto3
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyyaml~=5.1" "pyyaml" \
      --replace "boto3~=1.9, >=1.9.56" "boto3"
  '';

  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "serverlessrepo" ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-serverlessrepo-python";
    description = "Helpers for working with the AWS Serverless Application Repository";
    longDescription = ''
      A Python library with convenience helpers for working with the
      AWS Serverless Application Repository.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ dhkl ];
  };
}
