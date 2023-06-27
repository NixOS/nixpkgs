{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "5.0.9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "uproot5";
    rev = "refs/tags/v${version}";
    hash = "sha256-7TCwVqSwgjM01FE3KMXBbvOKbLsk6xWNxQA46B45RFw=";
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
