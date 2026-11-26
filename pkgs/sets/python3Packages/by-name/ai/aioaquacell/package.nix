{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  aws-request-signer,
  boto3,
  botocore,
  pycognito,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioaquacell";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jordi1990";
    repo = "aioaquacell";
    tag = finalAttrs.version;
    hash = "sha256-ghzuNIqpDwrt2EJ8u74yF5pWdS2nR3FvbPdHQMH4KxE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aws-request-signer
    boto3
    botocore
    pycognito
  ];

  pythonImportsCheck = [ "aioaquacell" ];

  doCheck = false; # no tests

  meta = {
    changelog = "https://github.com/Jordi1990/aioaquacell/releases/tag/${finalAttrs.version}";
    description = "Asynchronous library to retrieve details of your Aquacell water softener device";
    homepage = "https://github.com/Jordi1990/aioaquacell";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
