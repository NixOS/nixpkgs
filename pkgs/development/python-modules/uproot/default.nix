{ lib
, fetchFromGitHub
, buildPythonPackage
, awkward
, numpy
, lz4
, xxhash
, zstandard
, pytestCheckHook
, scikit-hep-testdata
}:

buildPythonPackage rec {
  pname = "uproot";
  version = "4.1.5";

  # fetch from github for tests
  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "uproot4";
    rev = version;
    sha256 = "sha256-zsmAdqoWvFhRRRw4fdbRhhKkDV5oP/eYsfpA0AVqAnI=";
  };

  propagatedBuildInputs = [
    awkward
    numpy
    lz4
    xxhash
    zstandard
  ];

  checkInputs = [
    pytestCheckHook
    scikit-hep-testdata
  ];
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';
  disabledTests = [
    # tests that try to download files
    "test_http"
    "test_no_multipart"
    "test_fallback"
    "test_pickle_roundtrip_http"
  ];
  disabledTestPaths = [
    # tests that try to download files
    "tests/test_0066-fix-http-fallback-freeze.py"
    "tests/test_0088-read-with-http.py"
    "tests/test_0220-contiguous-byte-ranges-in-http.py"
  ];
  pythonImportsCheck = [ "uproot" ];

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/uproot4";
    description = "ROOT I/O in pure Python and Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
