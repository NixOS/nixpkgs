{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "spidev";
  version = "3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "doceme";
    repo = "py-spidev";
    tag = "v${version}";
    hash = "sha256-XLCWuLjBpsEGjP3yUNbFMxJQ1m9S7TY0LfVVteUU2bY=";
  };

  build-system = [ setuptools ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "spidev" ];

  meta = with lib; {
    changelog = "https://github.com/doceme/py-spidev/releases/tag/${src.tag}";
    homepage = "https://github.com/doceme/py-spidev";
    description = "Python bindings for Linux SPI access through spidev";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
