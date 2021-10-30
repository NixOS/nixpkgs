{ lib
, aiofiles
, aiohttp
, aioresponses
, aiounittest
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pubnub
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "yalexs";
  version = "1.1.13";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    sha256 = "0938540n60xv7kxam3azszn3nj0mnhhgh5p4hgbfxj43bkwpqz4n";
  };

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    pubnub
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
    substituteInPlace setup.py --replace '"vol",' ""
  '';

  pythonImportsCheck = [ "yalexs" ];

  meta = with lib; {
    description = "Python API for Yale Access (formerly August) Smart Lock and Doorbell";
    homepage = "https://github.com/bdraco/yalexs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
