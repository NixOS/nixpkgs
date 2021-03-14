{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, asynctest
, stdiomask
, cryptography
, pytestcov
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "subarulink";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "G-Two";
    repo = pname;
    rev = "subaru-v${version}";
    sha256 = "0mhy4np3g10k778062sp2q65cfjhp4y1fghn8yvs6qg6jmg047z6";
  };

  propagatedBuildInputs = [ aiohttp stdiomask ];

  checkInputs = [
    asynctest
    cryptography
    pytest-asyncio
    pytestcov
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "subarulink" ];

  meta = with lib; {
    description = "Python module for interacting with STARLINK-enabled vehicle";
    homepage = "https://github.com/G-Two/subarulink";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
