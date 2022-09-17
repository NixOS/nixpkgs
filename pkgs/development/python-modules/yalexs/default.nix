{ lib
, aiofiles
, aiohttp
, aioresponses
, aiounittest
, asynctest
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
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7+4Icg3E6xrWmxObNzNuDc+MXJ9rnbgBHMK4uPBJeuY=";
  };

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    pubnub
    pyjwt
    python-dateutil
    requests
  ];

  checkInputs = [
    aioresponses
    aiounittest
    asynctest
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
