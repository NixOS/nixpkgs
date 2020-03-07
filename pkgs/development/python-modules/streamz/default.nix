{ lib, buildPythonPackage, fetchPypi, fetchpatch
, tornado
, toolz
, zict
, six
, pytest
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

  patches = [
    # fix networkx rename issue of GiGraph.node -> DiGraph.nodes, remove on next bump
    ( fetchpatch {
      url = "https://github.com/python-streamz/streamz/commit/f8b7bdb6bcb9dd107677e82e755ff4695bf0c4be.patch";
      sha256 = "1b2frp0j369gf55plxk2pigblhsc44m0rm9az01y83cjlcm26x2s";
    })
    # also, fix networkx rename issue of GiGraph.node -> DiGraph.nodes, remove on next bump
    ( fetchpatch {
      url = "https://github.com/python-streamz/streamz/commit/f7603f4cbea54f1548885881206a3ca9d6e52250.patch";
      sha256 = "1125kqiaz6b3cifz0yk1zrkxj5804lfzl4kc58jhqajv8rsrbs45";
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
    confluent-kafka
    distributed
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
