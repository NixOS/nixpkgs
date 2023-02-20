{ lib
, aiofiles
, aiohttp
, aioresponses
, aiounittest
, buildPythonPackage
, fetchFromGitHub
, pubnub
, pyjwt
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "yalexs";
  version = "1.2.8";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-SdWfhA6mroZnqHQYPieuZvox+OGEHWOTlfuHqu5r0cg=";
  };

  propagatedBuildInputs = [
    aiofiles
    aiohttp
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

  postPatch = ''
    # Not used requirement
    substituteInPlace setup.py \
      --replace '"vol",' ""
  '';

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
