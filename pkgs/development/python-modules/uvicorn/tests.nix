{ stdenv
, buildPythonPackage
<<<<<<< HEAD
, a2wsgi
, uvicorn
, httpx
, pytestCheckHook
, pytest-mock
=======
, asgiref
, uvicorn
, httpx
, pytest-asyncio
, pytestCheckHook
, pytest-mock
, requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, trustme
, watchgod
, wsproto
}:

<<<<<<< HEAD
buildPythonPackage {
  pname = "uvicorn-tests";
  inherit (uvicorn) version;
=======
buildPythonPackage rec {
  pname = "uvicorn-tests";
  inherit (uvicorn) version;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "other";

  src = uvicorn.testsout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
<<<<<<< HEAD
    uvicorn
    httpx
    pytestCheckHook
    pytest-mock
    trustme

    # strictly optional dependencies
    a2wsgi
=======
    asgiref
    uvicorn
    httpx
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    requests
    trustme

    # strictly optional dependencies
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

