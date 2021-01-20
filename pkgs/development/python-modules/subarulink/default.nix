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
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "G-Two";
    repo = pname;
    rev = "subaru-v${version}";
    sha256 = "1ink9bhph6blidnfsqwq01grhp7ghacmkd4vzgb9hnhl9l52s1jq";
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
