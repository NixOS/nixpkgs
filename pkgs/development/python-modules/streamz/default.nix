{ lib
, buildPythonPackage
, fetchPypi
, tornado
, toolz
, zict
, six
, pytest
, networkx
, distributed
, confluent-kafka
, graphviz
}:

buildPythonPackage rec {
  pname = "streamz";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "80c9ded1d6e68d3b78339deb6e9baf93a633d84b4a8875221e337ac06890103f";
  };

  checkInputs = [ pytest networkx distributed confluent-kafka graphviz ];
  propagatedBuildInputs = [
    tornado
    toolz
    zict
    six
  ];

  # Disable test_tcp_async because fails on sandbox build
  checkPhase = ''
    pytest --deselect=streamz/tests/test_sources.py::test_tcp_async
  '';

  meta = with lib; {
    description = "Pipelines to manage continuous streams of data";
    homepage = https://github.com/mrocklin/streamz/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
