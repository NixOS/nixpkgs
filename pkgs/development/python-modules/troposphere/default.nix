{
  lib,
  awacs,
  buildPythonPackage,
  cfn-flip,
  fetchFromGitHub,
  pythonOlder,
  typing-extensions,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "troposphere";
  version = "4.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cloudtools";
    repo = "troposphere";
    tag = version;
    hash = "sha256-IqWgqkxJ4EFNt9z58cuCqSTnlbMNi7bFhA04hgQjG8E=";
  };

  propagatedBuildInputs = [ cfn-flip ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  nativeCheckInputs = [
    awacs
    unittestCheckHook
  ];

  optional-dependencies = {
    policy = [ awacs ];
  };

  pythonImportsCheck = [ "troposphere" ];

  meta = with lib; {
    description = "Library to create AWS CloudFormation descriptions";
    homepage = "https://github.com/cloudtools/troposphere";
    changelog = "https://github.com/cloudtools/troposphere/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
