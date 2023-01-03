{ stdenv
, buildPythonPackage
, asgiref
, uvicorn
, httpx
, pytest-asyncio
, pytestCheckHook
, pytest-mock
, requests
, trustme
, watchgod
, wsproto
}:

buildPythonPackage rec {
  pname = "uvicorn-tests";
  inherit (uvicorn) version;

  format = "other";

  src = uvicorn.testsout;

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    asgiref
    uvicorn
    httpx
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    requests
    trustme

    # strictly optional dependencies
    watchgod
    wsproto
  ]
  ++ uvicorn.optional-dependencies.standard;

  doCheck = !stdenv.isDarwin;

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_supported_upgrade_request"
    "test_invalid_upgrade"
    "test_no_server_headers"
    "test_multiple_server_header"
  ];
}

