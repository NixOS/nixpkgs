{ lib
, stdenv
, buildPythonPackage
, click
, colorama
, coverage
, fetchpatch
, fetchPypi
, flit-core
, pytest-sugar
, pytest-xdist
, pytestCheckHook
, pythonOlder
, rich
, shellingham
, typing-extensions
}:

buildPythonPackage rec {
  pname = "typer";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UJIv15rqL0dRqOBAj/ENJmK9DIu/qEdVppnzutopeLI=";
  };

  patches = [
    # https://github.com/tiangolo/typer/pull/651
    (fetchpatch {
      name = "unpin-flit-core-dependency.patch";
      url = "https://github.com/tiangolo/typer/commit/78a0ee2eec9f54ad496420e177fdaad84984def1.patch";
      hash = "sha256-VVUzFvF2KCXXkCfCU5xu9acT6OLr+PlQQPeVGONtU4A=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    click
    typing-extensions
  ];

  passthru.optional-dependencies = {
    all = [
      colorama
      shellingham
      rich
    ];
  };

  nativeCheckInputs = [
    coverage # execs coverage in tests
    pytest-sugar
    pytest-xdist
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all;

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    "test_scripts"
    # Likely related to https://github.com/sarugaku/shellingham/issues/35
    # fails also on Linux
    "test_show_completion"
    "test_install_completion"
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    "test_install_completion"
  ];

  pythonImportsCheck = [
    "typer"
  ];

  meta = with lib; {
    description = "Library for building CLI applications";
    homepage = "https://typer.tiangolo.com/";
    changelog = "https://github.com/tiangolo/typer/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ winpat ];
  };
}
