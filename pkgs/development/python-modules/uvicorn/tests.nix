{
  stdenv,
  buildPythonPackage,
  a2wsgi,
  uvicorn,
  httpx,
  pytestCheckHook,
  pytest-mock,
  trustme,
  typing-extensions,
  watchgod,
  wsproto,
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
    typing-extensions

    # strictly optional dependencies
    a2wsgi
    watchgod
    wsproto
  ] ++ uvicorn.optional-dependencies.standard;

  doCheck = !stdenv.hostPlatform.isDarwin;

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_supported_upgrade_request"
    "test_invalid_upgrade"
    "test_no_server_headers"
    "test_multiple_server_header"
  ];
}
