{ stdenv
, lib
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
, fetchpatch
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

  patches = [
    # remove with next bump
    (fetchpatch {
      name = "fix-tests-against-distributed-2021.10.0.patch";
      url = "https://github.com/python-streamz/streamz/commit/5bd3bc4d305ff40c740bc2550c8491be9162778a.patch";
      sha256 = "1xzxcbf7yninkyizrwm3ahqk6ij2fmh0454iqjx2n7mmzx3sazx7";
      includes = ["streamz/tests/test_dask.py"];
    })
  ];

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

  pythonImportsCheck = [
    "streamz"
  ];

  disabledTests = [
    # test_tcp_async fails on sandbox build
    "test_tcp_async"
    "test_tcp"
    "test_partition_timeout"
    # flaky
    "test_from_iterable_backpressure"
  ];
  disabledTestPaths = [
    # disable kafka tests
    "streamz/tests/test_kafka.py"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Pipelines to manage continuous streams of data";
    homepage = "https://github.com/python-streamz/streamz";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
