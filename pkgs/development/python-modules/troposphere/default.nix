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
  version = "4.10.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cloudtools";
    repo = "troposphere";
    tag = version;
    hash = "sha256-o8Wq1kRBg4yFozQo02jlR5huBtpuLGZLTkLG5LuoI8s=";
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
