{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  deprecation,
}:

buildPythonPackage rec {
  pname = "splunk-sdk";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "splunk-sdk-python";
    tag = version;
    hash = "sha256-N+QQ4DSkx7yakROhcJ2ISXPWFa7BXDeSUULNquhDPrg=";
  };

  build-system = [ setuptools ];

  dependencies = [ deprecation ];

  pythonImportsCheck = [ "splunklib" ];

  meta = {
    description = "The Splunk Enterprise Software Development Kit (SDK) for Python";
    homepage = "https://github.com/splunk/splunk-sdk-python";
    changelog = "https://github.com/splunk/splunk-sdk-python/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ levigross ];
  };
}
