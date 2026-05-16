{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "spidev";
  version = "3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doceme";
    repo = "py-spidev";
    tag = "v${version}";
    hash = "sha256-ysOLZWsMiHjPxQ7fMWsywp44vkNGFGH8n6X7zk7XQck=";
  };

  build-system = [ setuptools ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "spidev" ];

  meta = {
    changelog = "https://github.com/doceme/py-spidev/releases/tag/${src.tag}";
    homepage = "https://github.com/doceme/py-spidev";
    description = "Python bindings for Linux SPI access through spidev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.linux;
  };
}
