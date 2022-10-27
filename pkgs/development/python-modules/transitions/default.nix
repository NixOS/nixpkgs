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
