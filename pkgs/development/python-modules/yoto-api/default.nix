{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  aiomqtt,
}:

buildPythonPackage (finalAttrs: {
  pname = "yoto-api";
  version = "4.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cdnninja";
    repo = "yoto_api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cZbcRuw1AI1Xv9awfOJxMdsMuBVIWPUnjEJqhLNzf0s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiomqtt
  ];

  # All tests require access to and authentication with the Yoto API (api.yotoplay.com).
  doCheck = false;

  pythonImportsCheck = [ "yoto_api" ];

  meta = {
    changelog = "https://github.com/cdnninja/yoto_api/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/cdnninja/yoto_api";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ seberm ];
    license = lib.licenses.mit;
    description = "Python package that makes it a bit easier to work with the yoto play API";
  };
})
