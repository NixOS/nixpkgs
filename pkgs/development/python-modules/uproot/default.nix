{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, awkward
, hatchling
, importlib-metadata
, numpy
, packaging
, pytestCheckHook
, lz4
, pytest-timeout
, scikit-hep-testdata
, xxhash
, zstandard
}:

buildPythonPackage rec {
  pname = "uproot";
<<<<<<< HEAD
  version = "5.0.11";
=======
  version = "5.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "uproot5";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-qp1iffElJSAwqaycelnILBzeW8kG7Yy0R1bjMumW8UU=";
=======
    hash = "sha256-5XR92e3rQJbKojfQX+MjaF4SCKvV1xBu7hezaFrtJwc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    awkward
    numpy
    packaging
  ]  ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    lz4
    pytest-timeout
    scikit-hep-testdata
    xxhash
    zstandard
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  disabledTests = [
    # Tests that try to download files
    "test_http"
    "test_no_multipart"
    "test_fallback"
    "test_pickle_roundtrip_http"
  ];

  disabledTestPaths = [
    # Tests that try to download files
    "tests/test_0066-fix-http-fallback-freeze.py"
    "tests/test_0088-read-with-http.py"
    "tests/test_0220-contiguous-byte-ranges-in-http.py"
<<<<<<< HEAD
    "tests/test_0916-read-from-s3.py"
    "tests/test_0930-expressions-in-pandas.py"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "uproot"
  ];

  meta = with lib; {
    description = "ROOT I/O in pure Python and Numpy";
    homepage = "https://github.com/scikit-hep/uproot5";
    changelog = "https://github.com/scikit-hep/uproot5/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
