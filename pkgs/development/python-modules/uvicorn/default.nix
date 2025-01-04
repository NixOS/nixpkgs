{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  click,
  h11,
  httptools,
  python-dotenv,
  pyyaml,
  typing-extensions,
  uvloop,
  watchfiles,
  websockets,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "uvicorn";
  version = "0.32.0";
  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "encode";
    repo = "uvicorn";
    rev = "refs/tags/${version}";
    hash = "sha256-LTioJNDq1zsy/FO6lBgRW8Ow5qyxUD8NjNCj4nIrVDM=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  build-system = [ hatchling ];

  dependencies = [
    click
    h11
  ] ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  optional-dependencies.standard = [
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

  pythonImportsCheck = [ "uvicorn" ];

  # check in passthru.tests.pytest to escape infinite recursion with httpx/httpcore
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    homepage = "https://www.uvicorn.org/";
    changelog = "https://github.com/encode/uvicorn/blob/${src.rev}/CHANGELOG.md";
    description = "Lightning-fast ASGI server";
    mainProgram = "uvicorn";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
