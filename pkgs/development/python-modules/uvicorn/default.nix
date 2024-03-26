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
  version = "0.27.1";
  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-p0iPQE66RJfd811x6cnv7m3yvD/L9v7evBXlaIQSE0M=";
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
    mainProgram = "uvicorn";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
