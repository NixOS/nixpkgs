{ lib
, buildPythonPackage
, fetchPypi
, six
, pygraphviz
, pytestCheckHook
, mock
, graphviz
, pycodestyle
}:

buildPythonPackage rec {
  pname = "transitions";
  version = "0.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c60ec0828cd037820726283cad5d4d77a5e31514e058b51250420e9873e9bc7";
  };

  propagatedBuildInputs = [
    six
    pygraphviz # optional
  ];

  checkInputs = [
    pytestCheckHook
    mock
    graphviz
    pycodestyle
  ];

  disabledTests = [
    # Fontconfig error: Cannot load default config file
    "test_diagram"
  ];

  meta = with lib; {
    homepage = "https://github.com/pytransitions/transitions";
    description = "A lightweight, object-oriented finite state machine implementation in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
