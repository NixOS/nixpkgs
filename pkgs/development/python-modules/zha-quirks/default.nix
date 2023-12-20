{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, zigpy
}:

buildPythonPackage rec {
  pname = "zha-quirks";
  version = "0.0.107";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zha-device-handlers";
    rev = "refs/tags/${version}";
    hash = "sha256-JHf6PZDK7yjyHjjUhkNpqEINCaY916wX5rXaw1Fx1ro=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/zigpy/zha-device-handlers/pull/2787
      name = "zigpy-0.60-compat.patch";
      url = "https://github.com/zigpy/zha-device-handlers/commit/f497ccd2437ae9a24b9afdb84f11fc27a30df211.patch";
      hash = "sha256-ICatiA0QRmfJ4Vf4LWyUJI5TLeWoikII49HSBir5WNI=";
    })
  ];

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
