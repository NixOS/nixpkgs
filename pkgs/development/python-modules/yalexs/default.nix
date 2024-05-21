{
  lib,
  aiofiles,
  aiohttp,
  aioresponses,
  aiounittest,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  pubnub,
  pyjwt,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "yalexs";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "yalexs";
    rev = "refs/tags/v${version}";
    hash = "sha256-+Sn+d6CuxIUEDLkDvcq7OT3AumElJFfWCwM02LPIeyg=";
  };

  postPatch = ''
    # Not used requirement
    substituteInPlace setup.py \
      --replace-fail '"vol",' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    ciso8601
    pubnub
    pyjwt
    python-dateutil
    requests
  ];

  # aiounittest is not supported on 3.12
  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [
    aioresponses
    aiounittest
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "yalexs" ];

  meta = with lib; {
    description = "Python API for Yale Access (formerly August) Smart Lock and Doorbell";
    homepage = "https://github.com/bdraco/yalexs";
    changelog = "https://github.com/bdraco/yalexs/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
