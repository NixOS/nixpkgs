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
  version = "4.10.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cloudtools";
    repo = "troposphere";
    tag = version;
    hash = "sha256-Pna5L2uO8KRN0L1XXRdFNWlPwNW9lAfcGwKiyK3ihgE=";
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
