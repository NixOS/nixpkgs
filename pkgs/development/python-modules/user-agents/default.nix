{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ua-parser,
}:

buildPythonPackage (finalAttrs: {
  pname = "user-agents";
  version = "2.2.0";
  pyproject = true;

  __structuredAttrs = true;

  # PyPI is missing devices.json
  src = fetchFromGitHub {
    owner = "selwin";
    repo = "python-user-agents";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qhBMQY9T3WAVx35e918MHkU4ERRwkUAo7FGwICSWi10=";
  };

  build-system = [ setuptools ];

  dependencies = [ ua-parser ];

  pythonImportsCheck = [ "user_agents" ];

  meta = {
    description = "Python library to identify devices by parsing user agent strings";
    homepage = "https://github.com/selwin/python-user-agents";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
