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
<<<<<<< HEAD
  version = "0.38.0";
=======
  version = "0.35.0";
  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "encode";
    repo = "uvicorn";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-A0YpFA/Oug5a37+33ac8++lh30jzRl48IhC8pflZ0S0=";
=======
    hash = "sha256-6tuLL0KMggujYI97HSSBHjiLrePwEkxFHjq2HWl8kqE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "testsout"
  ];

  build-system = [ hatchling ];

  dependencies = [
    click
    h11
  ]
  ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://www.uvicorn.org/";
    changelog = "https://github.com/encode/uvicorn/blob/${src.tag}/CHANGELOG.md";
    description = "Lightning-fast ASGI server";
    mainProgram = "uvicorn";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wd15 ];
=======
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
