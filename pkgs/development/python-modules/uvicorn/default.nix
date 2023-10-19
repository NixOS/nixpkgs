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
, watchfiles
, websockets
, hatchling
, pythonOlder
}:

buildPythonPackage rec {
  pname = "uvicorn";
  version = "0.23.1";
  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    hash = "sha256-X/G6K0X4G1EsMIBpvqy62zZ++8paTHNqgYLi+B7YK+0=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    click
    h11
  ] ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  passthru.optional-dependencies.standard = [
    httptools
    python-dotenv
    pyyaml
    uvloop
    watchfiles
    websockets
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
