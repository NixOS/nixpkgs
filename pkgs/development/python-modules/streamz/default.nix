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
}:

buildPythonPackage rec {
  pname = "streamz";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vzmwnj12ij0cqhggys2dqv3b0v935yfzhcjwl5jw206vlla22bw";
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
