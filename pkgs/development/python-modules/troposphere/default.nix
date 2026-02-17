{
  lib,
  awacs,
  buildPythonPackage,
  cfn-flip,
  fetchFromGitHub,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "troposphere";
  version = "4.9.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cloudtools";
    repo = "troposphere";
    tag = version;
    hash = "sha256-s7eb8W/QjD+lNmq3bPhCP3tH8VV/xNf3cE2dGzWAgFk=";
  };

  propagatedBuildInputs = [ cfn-flip ];

  nativeCheckInputs = [
    awacs
    unittestCheckHook
  ];

  optional-dependencies = {
    policy = [ awacs ];
  };

  pythonImportsCheck = [ "troposphere" ];

  meta = {
    description = "Library to create AWS CloudFormation descriptions";
    homepage = "https://github.com/cloudtools/troposphere";
    changelog = "https://github.com/cloudtools/troposphere/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
}
