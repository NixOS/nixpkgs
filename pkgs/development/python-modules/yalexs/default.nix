{ lib
, aiofiles
, aiohttp
, aioresponses
, aiounittest
, buildPythonPackage
, ciso8601
, fetchFromGitHub
, pubnub
, pyjwt
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
, requests-mock
, setuptools
}:

buildPythonPackage rec {
  pname = "yalexs";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "yalexs";
    rev = "refs/tags/v${version}";
    hash = "sha256-ozohIzw80YfyB0sxXQ9MY6VpF+EDDvXZYfkpuloE4AU=";
  };

  postPatch = ''
    # Not used requirement
    substituteInPlace setup.py \
      --replace-fail '"vol",' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    ciso8601
    pubnub
    pyjwt
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    aioresponses
    aiounittest
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "yalexs"
  ];

  meta = with lib; {
    description = "Python API for Yale Access (formerly August) Smart Lock and Doorbell";
    homepage = "https://github.com/bdraco/yalexs";
    changelog = "https://github.com/bdraco/yalexs/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
