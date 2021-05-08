{ lib, buildPythonPackage, fetchPypi
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
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04446ece273c041506b1642bd3d8380367a8372196be4d6d6d03faafadc590b2";
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
