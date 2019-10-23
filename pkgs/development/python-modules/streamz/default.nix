{ lib
, buildPythonPackage
, fetchPypi
, tornado
, toolz
, zict
, six
, pytest_4
, networkx
, distributed
, confluent-kafka
, graphviz
, requests
}:

buildPythonPackage rec {
  pname = "streamz";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "127rpdjgkcyjifmkqbhmqfbzlgi32n54rybrdxja610qr906y40c";
  };

  propagatedBuildInputs = [
    tornado
    toolz
    zict
    six
  ];

  checkInputs = [
    confluent-kafka
    distributed
    graphviz
    networkx
    pytest_4
    requests
  ];

  # Disable test_tcp_async because fails on sandbox build
  checkPhase = ''
    pytest --deselect=streamz/tests/test_sources.py::test_tcp_async \
      --deselect=streamz/tests/test_sources.py::test_tcp
  '';

  meta = with lib; {
    description = "Pipelines to manage continuous streams of data";
    homepage = "https://github.com/mrocklin/streamz";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
