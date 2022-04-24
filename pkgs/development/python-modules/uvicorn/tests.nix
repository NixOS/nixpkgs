{ stdenv
, buildPythonPackage
, uvicorn
, httpx
, pytest-asyncio
, pytestCheckHook
, pytest-mock
, requests
, trustme
}:

buildPythonPackage rec {
  pname = "uvicorn-tests";
  inherit (uvicorn) version;

  src = uvicorn.testsout;

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    uvicorn
    httpx
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    requests
    trustme
  ];

  doCheck = !stdenv.isDarwin;

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_supported_upgrade_request"
    "test_invalid_upgrade"
  ];
}

