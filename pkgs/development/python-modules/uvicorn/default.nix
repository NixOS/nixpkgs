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
  version = "0.16.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "14jih6j4q2qp5c9rgl798i5p51b4y6zkkj434q2l1naw0csphk4s";
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
