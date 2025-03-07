{
  lib,
  stdenv,
  buildPythonPackage,
  click,
  colorama,
  coverage,
  fetchPypi,
  pdm-backend,
  pytest-sugar,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  rich,
  shellingham,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "typer";
  version = "0.12.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SecxMUgdgEKI72JZjZehzu8wWJBapTahE0+QiRujVII=";
  };

  nativeBuildInputs = [ pdm-backend ];

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
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [ "test_install_completion" ];

  pythonImportsCheck = [ "typer" ];

  meta = with lib; {
    description = "Library for building CLI applications";
    homepage = "https://typer.tiangolo.com/";
    changelog = "https://github.com/tiangolo/typer/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ winpat ];
  };
}
