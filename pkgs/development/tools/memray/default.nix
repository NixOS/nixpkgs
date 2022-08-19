{ lib
, fetchFromGitHub
, libunwind
, lz4
, pkg-config
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "memray";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8uFAWcf9ookmFAnCdA97+oade+fECt58DuDSk1uTMQI=";
  };

  buildInputs = [
    libunwind
    lz4
    pkg-config
  ] ++ (with python3.pkgs; [
    cython
  ]);

  propagatedBuildInputs = with python3.pkgs; [
    jinja2
    rich
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.11") [
    greenlet
  ];

  pythonImportsCheck = [
    "memray"
  ];

  pytestFlagsArray = [
    "tests"
  ];

  disabledTests = [
    # Import issue
    "test_header_allocator"
  ];

  disabledTestPaths = [
    # Very time-consuming and some tests fails (performance-related?)
    "tests/integration/test_main.py"
  ];

  meta = with lib; {
    description = "Memory profiler for Python";
    homepage = "https://bloomberg.github.io/memray/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
