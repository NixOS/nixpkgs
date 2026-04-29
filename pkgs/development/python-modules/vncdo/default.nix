{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pexpect,
  pillow,
  cryptography,
  pytestCheckHook,
  pyvirtualdisplay,
  setuptools,
  twisted,
}:

buildPythonPackage rec {
  pname = "vncdo";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "vncdotool";
    tag = "v${version}";
    hash = "sha256-CXxuaAi/B7NiGp1dhhe7iBw0qOdPfsKg7zMMwavGCW8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pillow
    cryptography
    twisted
  ];

  nativeCheckInputs = [
    pexpect
    pytestCheckHook
    pyvirtualdisplay
  ];

  pythonImportsCheck = [ "vncdotool" ];

  meta = {
    description = "Command line VNC client and Python library";
    homepage = "https://github.com/sibson/vncdotool";
    changelog = "https://github.com/sibson/vncdotool/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "vncdo";
    platforms = with lib.platforms; linux ++ darwin;
  };
}
