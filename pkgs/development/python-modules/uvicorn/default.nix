{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, click
, h11
, httptools
, uvloop
, websockets
, wsproto
, pytestCheckHook
, requests
, isPy27
, trustme
, pyyaml
, typing-extensions
, pytest-mock
}:

buildPythonPackage rec {
  pname = "uvicorn";
  version = "0.12.2";
  disabled = isPy27;

  # PyPi doesn't have tests bundled
  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "02ly3ffqzmd90n8wrf2073y98v9f33sc44mx6zx578hlz14pxclr";
  };

  propagatedBuildInputs = [
    click
    h11
    httptools
    uvloop
    websockets
    wsproto
  ] ++ lib.optional (pythonOlder "3.8") [ typing-extensions ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    pyyaml
    requests
    trustme
  ];

  pythonImportsCheck = [ "uvicorn" ];

  __darwinAllowLocalNetworking = true;

  pytestFlagsArray = [
    # watchgod required the watchgod package, which isn't available in nixpkgs
    "--ignore=tests/supervisors/test_watchgodreload.py"
  ];

  meta = with lib; {
    homepage = "https://www.uvicorn.org/";
    description = "The lightning-fast ASGI server";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
