{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  deprecation,
}:

buildPythonPackage (finalAttrs: {
  pname = "splunk-sdk";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "splunk-sdk-python";
    tag = finalAttrs.version;
    hash = "sha256-wVndu+f7+6hWSnNZSZatTVuRxjZDA8o9MKMB3QzEOZQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ deprecation ];

  pythonImportsCheck = [ "splunklib" ];

  meta = {
    description = "Splunk Enterprise Software Development Kit (SDK) for Python";
    homepage = "https://github.com/splunk/splunk-sdk-python";
    changelog = "https://github.com/splunk/splunk-sdk-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ levigross ];
  };
})
