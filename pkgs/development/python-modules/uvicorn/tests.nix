{ stdenv
, buildPythonPackage
, a2wsgi
, uvicorn
, httpx
, pytestCheckHook
, pytest-mock
, trustme
, watchgod
, wsproto
}:

buildPythonPackage {
  pname = "uvicorn-tests";
  inherit (uvicorn) version;
  format = "other";

  src = uvicorn.testsout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    uvicorn
    httpx
    pytestCheckHook
    pytest-mock
    trustme

    # strictly optional dependencies
    a2wsgi
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

