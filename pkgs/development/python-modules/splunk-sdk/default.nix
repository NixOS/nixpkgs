{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  deprecation,
}:

buildPythonPackage rec {
  pname = "splunk-sdk";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "splunk-sdk-python";
    tag = version;
    hash = "sha256-+ae4/Q7Rx6K35RZuTOc/MDIgnX9hqswgZelnRvFiaRM=";
  };

  build-system = [ setuptools ];

  dependencies = [ deprecation ];

  pythonImportsCheck = [ "splunklib" ];

  meta = {
    description = "Splunk Enterprise Software Development Kit (SDK) for Python";
    homepage = "https://github.com/splunk/splunk-sdk-python";
    changelog = "https://github.com/splunk/splunk-sdk-python/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ levigross ];
  };
}
