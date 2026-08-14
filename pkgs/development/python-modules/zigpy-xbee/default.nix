{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  pyserial-asyncio-fast,
  setuptools,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zigpy-xbee";
  version = "0.21.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-xbee";
    tag = version;
    hash = "sha256-ALwhl9WUDkv0POufF/G/rZrn+ITbMdh6y86lShy6ZTg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<2"' ""
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    zigpy
  ];

  # lacking zigpy 2.0 compat
  # https://github.com/zigpy/zigpy-xbee/pull/179
  doCheck = false;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pyserial-asyncio-fast
  ];

  disabledTests = [
    "test_connect" # Attempts to test ioctl
  ];

  meta = {
    changelog = "https://github.com/zigpy/zigpy-xbee/releases/tag/${version}";
    description = "Library which communicates with XBee radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-xbee";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    platforms = lib.platforms.linux;
  };
}
