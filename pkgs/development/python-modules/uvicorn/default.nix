{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, click
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
  version = "0.18.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    hash = "sha256-nxtDqYh2OmDtoV10CEBGYQrQBf+Xtuf5k9yR6UfCgYc=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  propagatedBuildInputs = [
    click
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
    changelog = "https://github.com/encode/uvicorn/blob/${src.rev}/CHANGELOG.md";
    description = "The lightning-fast ASGI server";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
