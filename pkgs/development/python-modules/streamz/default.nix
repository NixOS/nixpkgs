{ lib
, buildPythonPackage
, confluent-kafka
, distributed
, fetchPypi
, flaky
, graphviz
, networkx
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
, six
, toolz
, tornado
, zict
}:

buildPythonPackage rec {
  pname = "streamz";
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0wZ1ldLFRAIL9R+gLfwsFbL+gvdORAkYWNjnDmeafm8=";
  };

  propagatedBuildInputs = [
    networkx
    six
    toolz
    tornado
    zict
  ];

  checkInputs = [
    confluent-kafka
    distributed
    flaky
    graphviz
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  disabledTests = [
    # Disable test_tcp_async because fails on sandbox build
    "test_partition_timeout"
    "test_tcp_async"
    "test_tcp"
  ];

  disabledTestPaths = [
    # Disable kafka tests
    "streamz/tests/test_kafka.py"
  ];

  pythonImportsCheck = [
    "streamz"
  ];

  meta = with lib; {
    description = "Pipelines to manage continuous streams of data";
    homepage = "https://github.com/python-streamz/streamz";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
