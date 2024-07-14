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
    hash = "sha256-Zx9IA4Ej8SFDe3F+1R8lOlV3VZDwD7q2+8agH40FwBc=";
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

  pytestFlagsArray = [ "tests/unit" ];

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
