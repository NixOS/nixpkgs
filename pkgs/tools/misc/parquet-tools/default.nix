{ lib
, fetchFromGitHub
, python3Packages
}:

with python3Packages;

buildPythonApplication rec {
  pname = "parquet-tools";
  version = "0.2.14";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ktrueda";
    repo = "parquet-tools";
    rev = "refs/tags/${version}";
    hash = "sha256-2jIwDsxB+g37zV9hLc2VNC5YuZXTpTmr2aQ72AeHYJo=";
  };

  postPatch = ''
    substituteInPlace tests/test_inspect.py \
      --replace "parquet-cpp-arrow version 5.0.0" "parquet-cpp-arrow version ${pyarrow.version}" \
      --replace "serialized_size: 2222" "serialized_size: 2221" \
      --replace "format_version: 1.0" "format_version: 2.6"
  '';

  pythonRelaxDeps = [
    "halo"
    "tabulate"
    "thrift"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    boto3
    colorama
    halo
    pandas
    pyarrow
    tabulate
    thrift
  ];

  nativeCheckInputs = [
    moto
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # These tests try to read Python code as parquet and fail
    "test_local_wildcard"
    "test_local_and_s3_wildcard_files"
    # test file is 2 bytes bigger than expected
    "test_excute_simple"
  ];

  pythonImportsCheck = [
    "parquet_tools"
  ];

  meta = with lib; {
    description = "A CLI tool for parquet files";
    homepage = "https://github.com/ktrueda/parquet-tools";
    changelog = "https://github.com/ktrueda/parquet-tools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "parquet-tools";
  };
}
