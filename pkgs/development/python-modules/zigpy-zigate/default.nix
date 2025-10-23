{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gpiozero,
  mock,
  pyusb,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  voluptuous,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zigpy-zigate";
  version = "0.13.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-zigate";
    tag = version;
    hash = "sha256-reOt0bPPkKDKeu8CESJtLDEmpkOmgopXk65BqBlBIhY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    gpiozero
    pyusb
    voluptuous
    zigpy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zigpy_zigate" ];

  disabledTestPaths = [
    # Fails in sandbox
    "tests/test_application.py "
  ];

  meta = with lib; {
    description = "Library which communicates with ZiGate radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-zigate";
    changelog = "https://github.com/zigpy/zigpy-zigate/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
