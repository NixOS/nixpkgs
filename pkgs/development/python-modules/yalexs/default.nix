{
  lib,
  aiofiles,
  aiohttp,
  aioresponses,
  aiounittest,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  freenub,
  poetry-core,
  pyjwt,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests-mock,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "yalexs";
  version = "6.4.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "yalexs";
    rev = "refs/tags/v${version}";
    hash = "sha256-vW6BMb0aaGGsXwZci5FE9VuSB/hi0pltIVH/OcL0mnw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "-v -Wdefault --cov=yalexs --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiofiles
    aiohttp
    ciso8601
    freenub
    pyjwt
    python-dateutil
    requests
    typing-extensions
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
