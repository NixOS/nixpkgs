{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, six
, pygraphviz
, pytestCheckHook
, mock
, graphviz
, pycodestyle
, fontconfig
}:

buildPythonPackage rec {
  pname = "transitions";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-L1TRG9siV3nX5ykBHpOp+3F2aM49xl+NT1pde6L0jhA=";
  };

  propagatedBuildInputs = [
    six
    pygraphviz # optional
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    graphviz
    pycodestyle
  ];

  preCheck = ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
    export HOME=$TMPDIR
  '';

  # upstream issue https://github.com/pygraphviz/pygraphviz/issues/441
  pytestFlagsArray = lib.optionals stdenv.isDarwin [
    "--deselect=tests/test_pygraphviz.py::PygraphvizTest::test_binary_stream"
    "--deselect=tests/test_pygraphviz.py::PygraphvizTest::test_diagram"
    "--deselect=tests/test_pygraphviz.py::TestPygraphvizNested::test_binary_stream"
    "--deselect=tests/test_pygraphviz.py::TestPygraphvizNested::test_diagram"
  ];

  pythonImportsCheck = [
    "transitions"
  ];

  meta = with lib; {
    homepage = "https://github.com/pytransitions/transitions";
    description = "A lightweight, object-oriented finite state machine implementation in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
