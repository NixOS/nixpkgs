{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pexpect,
  pillow,
  pycryptodomex,
  pytestCheckHook,
  pyvirtualdisplay,
  setuptools,
  twisted,
}:

buildPythonPackage rec {
  pname = "vncdo";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "vncdotool";
    tag = "v${version}";
    hash = "sha256-QrD6z/g85FwaZCJ1PRn8CBKCOQcbVjQ9g0NpPIxguqk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pillow
    pycryptodomex
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
