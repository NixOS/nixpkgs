{ lib
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
  version = "0.8.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0385975a842e885c1a55c719d2f90164471665794d39d51f9eb3f11e1d9c8ac";
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

  preCheck = ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
    export HOME=$TMPDIR
  '';

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/pytransitions/transitions/issues/563
    "test_multiple_models"
    "test_timeout"
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
