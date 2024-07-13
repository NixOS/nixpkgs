{
  lib,
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  stdiomask,
}:

buildPythonPackage rec {
  pname = "subarulink";
  version = "0.7.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "G-Two";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HKtToMh4dAUpA654tFkUEM9DLPGr9XRQK0ezYzNPzqk=";
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

  pythonImportsCheck = [ "subarulink" ];

  meta = with lib; {
    description = "Python module for interacting with STARLINK-enabled vehicle";
    mainProgram = "subarulink";
    homepage = "https://github.com/G-Two/subarulink";
    changelog = "https://github.com/G-Two/subarulink/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
