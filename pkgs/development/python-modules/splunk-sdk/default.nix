{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  deprecation,
}:

buildPythonPackage rec {
  pname = "splunk-sdk";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "splunk-sdk-python";
    tag = version;
    hash = "sha256-8544jRlv//Qkcq4JqrMOBZhFC6K6BI1WGT6PK4AwVvs=";
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
