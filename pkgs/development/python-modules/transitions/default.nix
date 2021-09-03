{ lib
, buildPythonPackage
, fetchPypi
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
  version = "0.8.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc2ec6d6b6f986cd7e28e119eeb9ba1c9cc51ab4fbbdb7f2dedad01983fd2de0";
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

  meta = with lib; {
    homepage = "https://github.com/pytransitions/transitions";
    description = "A lightweight, object-oriented finite state machine implementation in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
