{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, zigpy
}:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.108";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha-device-handlers";
    rev = "refs/tags/${version}";
    hash = "sha256-tn6ZI8lanQhWallvi/NwAWYPuSea+SlJX/6D1VdXRxM=";
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
    aiohttp
    zigpy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zhaquirks"
  ];

  meta = with lib; {
    description = "ZHA Device Handlers are custom quirks implementations for Zigpy";
    homepage = "https://github.com/dmulcahey/zha-device-handlers";
    changelog = "https://github.com/zigpy/zha-device-handlers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
