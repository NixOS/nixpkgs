{
  lib,
  awacs,
  buildPythonPackage,
  cfn-flip,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "troposphere";
  version = "4.10.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cloudtools";
    repo = "troposphere";
    tag = finalAttrs.version;
    hash = "sha256-o8Wq1kRBg4yFozQo02jlR5huBtpuLGZLTkLG5LuoI8s=";
  };

  build-system = [ setuptools ];

  dependencies = [ cfn-flip ];

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
    changelog = "https://github.com/cloudtools/troposphere/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
