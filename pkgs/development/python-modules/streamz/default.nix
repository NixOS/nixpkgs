{ lib, buildPythonPackage, fetchPypi, fetchpatch
, confluent-kafka
, distributed
, flaky
, graphviz
, networkx
, pytest
, requests
, six
, toolz
, tornado
, zict
, pythonOlder
}:

buildPythonPackage rec {
  pname = "streamz";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2ca46c9f77ec444310c6ee45b66e8d59bb3a04607a0386297c10668ba7fca3a";
  };

  propagatedBuildInputs = [
    networkx
    tornado
    toolz
    zict
    six
  ];

  checkInputs = [
    confluent-kafka
    distributed
    flaky
    graphviz
    pytest
    requests
  ];

  disabled = pythonOlder "3.6";

  # Disable test_tcp_async because fails on sandbox build
  # disable kafka tests
  checkPhase = ''
    pytest --deselect=streamz/tests/test_sources.py::test_tcp_async \
      --deselect=streamz/tests/test_sources.py::test_tcp \
      --ignore=streamz/tests/test_kafka.py
  '';

  meta = with lib; {
    description = "Pipelines to manage continuous streams of data";
    homepage = "https://github.com/python-streamz/streamz";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
