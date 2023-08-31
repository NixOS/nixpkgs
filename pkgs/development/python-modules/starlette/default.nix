{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "0.26.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-/zYqYmmCcOLU8Di9b4BzDLFtB5wYEEF1bYN6u2rb8Lg=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-29159.patch";
      url = "https://github.com/encode/starlette/commit/1797de464124b090f10cf570441e8292936d63e3.patch";
      hash = "sha256-IZFFc0hE4eBFMltpsNPMJ0u6mobrXtd87LXrUIGbBa0=";
    })
  ];

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
