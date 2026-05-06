{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  boto3,
}:

buildPythonPackage (finalAttrs: {
  pname = "watchtower";
  version = "3.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kislyuk";
    repo = "watchtower";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LHWNXmWS51d4Jp7zBJgEKvrQZxGEKuRmJwtxGCts+eE=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    boto3
  ];

  doCheck = false; # Tests require AWS credentials and network

  pythonImportsCheck = [ "watchtower" ];

  meta = {
    description = "CloudWatch logging handler for Python";
    longDescription = ''
      Watchtower is a log handler for Amazon Web Services CloudWatch Logs.
    '';
    homepage = "https://github.com/kislyuk/watchtower";
    changelog = "https://github.com/kislyuk/watchtower/blob/v${finalAttrs.version}/Changes.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
