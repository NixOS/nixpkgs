{ lib
, stdenv
, buildPythonPackage
, colorama
, fetchpatch
, fetchPypi
, flit-core
, click
, pytestCheckHook
, rich
, shellingham
, pytest-xdist
, pytest-sugar
, coverage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "typer";
  version = "0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LVcgpeY/c+rzHtqhX2q4fzXwaQ+MojMBfX0j10OpHXM=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    click
  ];

  passthru.optional-dependencies = {
    all = [
      colorama
      shellingham
      rich
    ];
  };

  checkInputs = [
    coverage # execs coverage in tests
    pytest-sugar
    pytest-xdist
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all;

  preCheck = ''
    export HOME=$(mktemp -d);
  '';
  disabledTests = lib.optionals stdenv.isDarwin [
    # likely related to https://github.com/sarugaku/shellingham/issues/35
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
    license = licenses.mit;
    maintainers = with maintainers; [ winpat ];
  };
}
