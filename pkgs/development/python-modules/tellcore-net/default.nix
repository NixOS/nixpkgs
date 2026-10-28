{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "tellcore-net";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "tellcore-net";
    tag = finalAttrs.version;
    hash = "sha256-yMNAu8iSFB2UDqJR3u2XFelpGRKzi/3HyuEbrZK6v8g=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "tellcorenet" ];

  meta = {
    description = "Python module that allows to run tellcore over TCP/IP";
    homepage = "https://github.com/home-assistant-libs/tellcore-net";
    changelog = "https://github.com/home-assistant-libs/tellcore-net/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
