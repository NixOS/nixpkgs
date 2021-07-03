{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, azure-common
, azure-core
, azure-storage-blob
, boto3
, google-cloud-storage
, requests
, moto
, parameterizedtestcase
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "smart-open";
  version = "5.1.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "smart_open";
    rev = "v${version}";
    sha256 = "0gv3vxpglnhh6d80wsqigxi7psn6s7ylz20kx5ahblcx5rqyhjmi";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    azure-storage-blob
    boto3
    google-cloud-storage
    requests
  ];

  checkInputs = [
    moto
    parameterizedtestcase
    pytestCheckHook
  ];

  pytestFlagsArray = [ "smart_open" ];

  disabledTestPaths = [
    "smart_open/tests/test_http.py"
    "smart_open/tests/test_s3.py"
    "smart_open/tests/test_s3_version.py"
    "smart_open/tests/test_sanity.py"
  ];

  disabledTests = [
    "test_compression_invalid"
    "test_gs_uri_contains_question_mark"
    "test_gzip_compress_sanity"
    "test_http"
    "test_ignore_ext"
    "test_initialize_write"
    "test_read_explicit"
    "test_s3_handles_querystring"
    "test_s3_uri_contains_question_mark"
    "test_webhdfs"
    "test_write"
  ];

  pythonImportsCheck = [ "smart_open" ];

  meta = with lib; {
    description = "Library for efficient streaming of very large file";
    homepage = "https://github.com/RaRe-Technologies/smart_open";
    license = licenses.mit;
    maintainers = with maintainers; [ jyp ];
  };
}
