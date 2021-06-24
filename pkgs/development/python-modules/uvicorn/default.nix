{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, click
, h11
, httptools
, uvloop
, websockets
, wsproto
, pytestCheckHook
, pytest-mock
, pyyaml
, requests
, trustme
, typing-extensions
, isPy27
, pythonOlder
}:

buildPythonPackage rec {
  pname = "uvicorn";
  version = "0.13.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "04zgmp9z46k72ay6cz7plga6d3w3a6x41anabm7ramp7jdqf6na9";
  };

  propagatedBuildInputs = [
    click
    h11
    httptools
    uvloop
    websockets
    wsproto
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    pyyaml
    requests
    trustme
  ];

  doCheck = !stdenv.isDarwin;

  __darwinAllowLocalNetworking = true;

  pytestFlagsArray = [
    # watchgod required the watchgod package, which isn't available in nixpkgs
    "--ignore=tests/supervisors/test_reload.py"
  ];

  disabledTests = [
    "test_supported_upgrade_request"
    "test_invalid_upgrade"
  ];

  meta = with lib; {
    homepage = "https://www.uvicorn.org/";
    description = "The lightning-fast ASGI server";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
