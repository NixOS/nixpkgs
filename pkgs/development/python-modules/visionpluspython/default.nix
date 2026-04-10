{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pyjwt,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "visionpluspython";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Watts-Digital";
    repo = "visionpluspython";
    tag = finalAttrs.version;
    hash = "sha256-jLn7L9yfyDN+cP5BuQqRQT+krDMLp3OmUOjUpOmFT8U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pyjwt
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "visionpluspython" ];

  meta = {
    changelog = "https://github.com/Watts-Digital/visionpluspython/releases/tag/${finalAttrs.src.tag}";
    description = "Python API wrapper for Watts Vision+ smart home system";
    homepage = "https://github.com/Watts-Digital/visionpluspython";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
