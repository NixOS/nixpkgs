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
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfdd42aa62df299f550768de5002ec83112136a34b44441db9d633b2df802fb4";
  };

  # Pytest 4.x fails to collect streamz-dataframe tests.
  # Removing them in v0.5.0. TODO: re-enable in a future release
  postPatch = ''
    rm -rf streamz/dataframe/tests/*.py
  '';

  checkInputs = [ pytest networkx distributed confluent-kafka graphviz ];
  propagatedBuildInputs = [
    tornado
    toolz
    zict
    six
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pipelines to manage continuous streams of data";
    homepage = https://github.com/mrocklin/streamz/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
