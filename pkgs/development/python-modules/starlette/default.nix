{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, hatchling

# runtime
, ApplicationServices
, anyio
, itsdangerous
, jinja2
, python-multipart
, pyyaml
, httpx
, typing-extensions

# tests
, pytestCheckHook
, pythonOlder
, trio
}:

buildPythonPackage rec {
  pname = "starlette";
<<<<<<< HEAD
  version = "0.27.0";
=======
  version = "0.26.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-qT3ZJQY5l1K88llJdKoSkwHvfcWwjH6JysMnHYGknqw=";
=======
    hash = "sha256-/zYqYmmCcOLU8Di9b4BzDLFtB5wYEEF1bYN6u2rb8Lg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  postPatch = ''
    # remove coverage arguments to pytest
    sed -i '/--cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    anyio
    itsdangerous
    jinja2
    python-multipart
    pyyaml
    httpx
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
  ];

  nativeCheckInputs = [
    pytestCheckHook
    trio
    typing-extensions
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
    "-W" "ignore::trio.TrioDeprecationWarning"
  ];

  disabledTests = [
    # asserts fail due to inclusion of br in Accept-Encoding
    "test_websocket_headers"
    "test_request_headers"
  ];

  pythonImportsCheck = [
    "starlette"
  ];

  meta = with lib; {
    changelog = "https://github.com/encode/starlette/releases/tag/${version}";
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
