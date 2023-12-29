{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-xbee";
  version = "0.20.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-xbee";
    rev = "refs/tags/${version}";
    hash = "sha256-H0rs4EOzz2Nx5YuwqTZp2FGF1z2phBgSIyraKHHx4RA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ', "setuptools-git-versioning<2"' "" \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyserial
    pyserial-asyncio
    zigpy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # fixed in https://github.com/zigpy/zigpy-xbee/commit/f85233fc28ae01c08267965e99a29e43b00e1561
    "test_shutdown"
  ];

  meta = with lib; {
    changelog = "https://github.com/zigpy/zigpy-xbee/releases/tag/${version}";
    description = "A library which communicates with XBee radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-xbee";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
