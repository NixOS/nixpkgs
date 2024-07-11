{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  fontconfig,
  graphviz,
  mock,
  pycodestyle,
  pygraphviz,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "transitions";
  version = "0.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NULDcQjpPirl8hUgjsVzLJSncpN4VKECzXNFuWf+5hs=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  disabledTests =
    [
      "test_diagram"
      "test_ordered_with_graph"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # Upstream issue https://github.com/pygraphviz/pygraphviz/issues/441
      "test_binary_stream"
    ];

  pythonImportsCheck = [ "transitions" ];

  meta = with lib; {
    homepage = "https://github.com/pytransitions/transitions";
    description = "Lightweight, object-oriented finite state machine implementation in Python";
    changelog = "https://github.com/pytransitions/transitions/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
