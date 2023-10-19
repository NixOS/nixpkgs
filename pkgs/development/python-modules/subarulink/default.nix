{ lib
, aiohttp
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
  version = "0.7.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "G-Two";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-SrOFKXh/wG2+HKaLvyNP6/Le9R3Ri7+/xsUBAazo7js=";
  };

  propagatedBuildInputs = [
    aiohttp
    stdiomask
  ];

  nativeCheckInputs = [
    cryptography
    pytest-asyncio
    pytestCheckHook
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
    changelog = "https://github.com/G-Two/subarulink/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
