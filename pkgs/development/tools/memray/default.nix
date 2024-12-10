{
  lib,
  fetchFromGitHub,
  libunwind,
  lz4,
  pkg-config,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "memray";
  version = "1.11.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "memray";
    rev = "refs/tags/v${version}";
    hash = "sha256-DaJ1Hhg7q4ckA5feUx0twOsmy28v5aBBCTUAkn43xAo=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libunwind
      lz4
    ]
    ++ (with python3.pkgs; [
      cython
    ]);

  propagatedBuildInputs = with python3.pkgs; [
    jinja2
    rich
  ];

  nativeCheckInputs =
    with python3.pkgs;
    [
      ipython
      pytestCheckHook
    ]
    ++ lib.optionals (pythonOlder "3.12") [
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
    "test_hybrid_stack_of_allocations_inside_ceval"
  ];

  disabledTestPaths = [
    # Very time-consuming and some tests fails (performance-related?)
    "tests/integration/test_main.py"
  ];

  meta = with lib; {
    description = "Memory profiler for Python";
    homepage = "https://bloomberg.github.io/memray/";
    changelog = "https://github.com/bloomberg/memray/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
