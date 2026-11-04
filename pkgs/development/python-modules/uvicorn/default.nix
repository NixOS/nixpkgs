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
  uvloop,
  watchfiles,
  websockets,
  hatchling,
}:

buildPythonPackage rec {
  pname = "uvicorn";
  version = "0.54.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kludex";
    repo = "uvicorn";
    tag = version;
    hash = "sha256-tfRdlqiMQ/+LZBQyTIAY+g6szR+JWn0X7Fd1yP3dntM=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  build-system = [ hatchling ];

  dependencies = [
    click
    h11
  ];

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

  meta = {
    homepage = "https://uvicorn.dev";
    changelog = "https://github.com/Kludex/uvicorn/blob/${src.tag}/docs/release-notes.md";
    description = "Lightning-fast ASGI server";
    mainProgram = "uvicorn";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      booxter
      wd15
    ];
  };
}
