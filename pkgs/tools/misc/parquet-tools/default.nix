{ lib
, fetchFromGitHub
, python3Packages
}:

with python3Packages;

buildPythonApplication rec {
  pname = "parquet-tools";
  version = "0.2.16";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ktrueda";
    repo = "parquet-tools";
    rev = "refs/tags/${version}";
    hash = "sha256-mV66R5ejfzH1IasmoyAWAH5vzrnLVVhOqKBMfWKIVY0=";
  };

  patches = [
    # support Moto 5.x
    # https://github.com/ktrueda/parquet-tools/pull/55
    ./moto5.patch
  ];

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

  # TestGetMetaData.test_inspect shells out to `parquet-tools` CLI entrypoint
  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs = [
    moto
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # test file is 2 bytes bigger than expected
    "test_excute_simple"
  ];

  pythonImportsCheck = [
    "parquet_tools"
  ];

  meta = with lib; {
    description = "CLI tool for parquet files";
    homepage = "https://github.com/ktrueda/parquet-tools";
    changelog = "https://github.com/ktrueda/parquet-tools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "parquet-tools";
  };
}
