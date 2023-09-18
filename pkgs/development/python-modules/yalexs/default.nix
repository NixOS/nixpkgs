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
}:

buildPythonPackage rec {
  pname = "yalexs";
  version = "1.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9rXAFMFpKF+oIKXSFLVCLDfdpMF837xRIEe3aH7ditc=";
  };

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
