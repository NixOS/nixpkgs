{ lib
, aiohttp
, asynctest
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, stdiomask
}:

buildPythonPackage rec {
  pname = "subarulink";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "G-Two";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-q+a+OFFMAGl8KQi+KZ8h21+Pj0XEqP9ZIJii2PCgD6E=";
  };

  propagatedBuildInputs = [
    aiohttp
    stdiomask
  ];

  checkInputs = [
    asynctest
    cryptography
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=subarulink" ""
  '';

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "subarulink"
  ];

  meta = with lib; {
    description = "Python module for interacting with STARLINK-enabled vehicle";
    homepage = "https://github.com/G-Two/subarulink";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
