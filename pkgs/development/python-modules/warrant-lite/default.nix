{
  lib,
  buildPythonPackage,
  fetchPypi,
  boto3,
  envs,
  python-jose,
  requests,
}:

buildPythonPackage rec {
  pname = "warrant-lite";
  version = "1.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FunWoslZn3o0WHet2+LtggO3bbbe2ULMXW93q07GxJ4=";
  };

  propagatedBuildInputs = [
    boto3
    envs
    python-jose
    requests
  ];

  postPatch = ''
    # requirements.txt is not part of the source
    substituteInPlace setup.py \
      --replace "parse_requirements('requirements.txt')," "[],"
  '';

  # Tests require credentials
  doCheck = false;

  pythonImportsCheck = [ "warrant_lite" ];

  meta = {
    description = "Module for process SRP requests for AWS Cognito";
    homepage = "https://github.com/capless/warrant-lite";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
