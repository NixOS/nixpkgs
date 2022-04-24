{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, asgiref
, click
, colorama
, h11
, httptools
, python-dotenv
, pyyaml
, typing-extensions
, uvloop
, watchgod
, websockets
, wsproto
, pythonOlder
}:

buildPythonPackage rec {
  pname = "uvicorn";
  version = "0.17.5";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "sha256-66wPVnBLy2HK4p0m/b/DRxy12sk8AsVFZoFVcWRkL4s=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  propagatedBuildInputs = [
    asgiref
    click
    colorama
    h11
    httptools
    python-dotenv
    pyyaml
    uvloop
    watchgod
    websockets
    wsproto
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  postInstall = ''
    mkdir $testsout
    cp -R tests $testsout/tests
  '';

  pythonImportsCheck = [
    "uvicorn"
  ];

  # check in passthru.tests.pytest to escape infinite recursion with httpx/httpcore
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    homepage = "https://www.uvicorn.org/";
    description = "The lightning-fast ASGI server";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
