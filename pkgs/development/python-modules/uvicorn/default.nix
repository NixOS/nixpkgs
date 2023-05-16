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
<<<<<<< HEAD
  version = "0.23.1";
  disabled = pythonOlder "3.8";
=======
  version = "0.20.0";
  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-X/G6K0X4G1EsMIBpvqy62zZ++8paTHNqgYLi+B7YK+0=";
=======
    hash = "sha256-yca6JI3/aqdZF7SxFeYr84GOeQnLBmbm1dIXjngX9Ng=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [
    "out"
    "testsout"
  ];

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    click
    h11
<<<<<<< HEAD
  ] ++ lib.optionals (pythonOlder "3.11") [
=======
  ] ++ lib.optionals (pythonOlder "3.8") [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
