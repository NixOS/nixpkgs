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
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "transitions";
  version = "0.9.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iB+3W7FlTtVdhgYLsGfyxxb44VX1e7c/1ETlNxOq/sg=";
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

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # sleep is not accurate on Darwin
    "tests/test_async.py"
  ];

  disabledTests = [
    "test_diagram"
    "test_ordered_with_graph"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Upstream issue https://github.com/pygraphviz/pygraphviz/issues/441
    "test_binary_stream"

    # sleep is not accurate on Darwin
    "test_timeout"
    "test_timeout_callbacks"
    "test_timeout_transitioning"
    "test_thread_access"
    "test_parallel_access"
    "test_parallel_deep"
    "test_conditional_access"
    "test_pickle"
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
