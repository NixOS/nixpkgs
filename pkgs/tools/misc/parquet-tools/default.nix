{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
}:

with python3Packages;

buildPythonApplication rec {
  pname = "parquet-tools";
  version = "0.2.9";
  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ktrueda";
    repo = "parquet-tools";
    rev = version;
    sha256 = "0aw0x7lhagp4dwis09fsizr7zbhdpliav0ns5ll5qny7x4m6rkfy";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ktrueda/parquet-tools/commit/1c70a07e1c9f17c8890d23aad3ded5dd6c706cb3.patch";
      sha256 = "08j1prdqj8ksw8gwiyj7ivshk82ahmywbzmywclw52nlnniig0sa";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'thrift = "^0.13.0"' 'thrift = "*"' \
      --replace 'halo = "^0.0.29"' 'halo = "*"'
    substituteInPlace tests/test_inspect.py \
      --replace "parquet-cpp-arrow version 5.0.0" "parquet-cpp-arrow version ${pyarrow.version}" \
      --replace "serialized_size: 2222" "serialized_size: 2221" \
      --replace "format_version: 1.0" "format_version: 2.6"
  '';

  nativeBuildInputs = [ poetry-core ];

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
    pytestCheckHook
    moto
    pytest-mock
  ];

  disabledTests = [
    # these tests try to read python code as parquet and fail
    "test_local_wildcard"
    "test_local_and_s3_wildcard_files"
  ];

  meta = with lib; {
    description = "A CLI tool for parquet files";
    homepage = "https://github.com/ktrueda/parquet-tools";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
