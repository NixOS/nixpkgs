{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, confluent-kafka
, distributed
, flaky
, graphviz
, networkx
, pytestCheckHook
, requests
, six
, toolz
, tornado
, zict
, pythonOlder
}:

buildPythonPackage rec {
  pname = "streamz";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vvyk9khxryqb0c0ji2fyy1gxchm5ky2v80zyl5h4i65saapa1nk";
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
    tornado
    toolz
    zict
    six
  ];

  checkInputs = [
    pytestCheckHook
    confluent-kafka
    distributed
    flaky
    graphviz
    requests
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

  disabled = pythonOlder "3.6";

  meta = with lib; {
    description = "Pipelines to manage continuous streams of data";
    homepage = "https://github.com/python-streamz/streamz";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
