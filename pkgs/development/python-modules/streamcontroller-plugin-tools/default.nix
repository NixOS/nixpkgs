{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  loguru,
  rpyc,
}:
buildPythonPackage rec {
  pname = "streamcontroller-plugin-tools";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "StreamController";
    repo = "streamcontroller-plugin-tools";
    rev = version;
    hash = "sha256-dQZPRSzHhI3X+Pf7miwJlECGFgUfp68PtvwXAmpq5/s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    loguru
    rpyc
  ];

  pythonImportsCheck = [ "streamcontroller_plugin_tools" ];

  meta = {
    description = "StreamController plugin tools";
    homepage = "https://github.com/StreamController/streamcontroller-plugin-tools";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.linux;
  };
}
