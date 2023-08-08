{ lib
, stdenv
, fetchPypi
, python3
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hatch";
  version = "1.7.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-evxwH9WzNoSmZQ4eyriVfhloX4JCQLp0WNys1m+Q+0Y=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    hatchling
    httpx
    hyperlink
    keyring
    packaging
    pexpect
    platformdirs
    pyperclip
    rich
    shellingham
    tomli-w
    tomlkit
    userpath
    virtualenv
  ];

  nativeCheckInputs = with python3.pkgs; [
    git
    pytestCheckHook
    pytest-mock
    pytest-xdist
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # AssertionError: assert (1980, 1, 2, 0, 0, 0) == (2020, 2, 2, 0, 0, 0)
    "test_default"
    "test_explicit_path"
    "test_default_auto_detection"
    "test_editable_default"
    "test_editable_default_extra_dependencies"
    "test_editable_default_force_include"
    "test_editable_default_force_include_option"
    "test_editable_exact"
    "test_editable_exact_extra_dependencies"
    "test_editable_exact_force_include"
    "test_editable_exact_force_include_option"
    "test_editable_exact_force_include_build_data_precedence"
    "test_editable_pth"
    # AssertionError: assert len(extract_installed_requirements(output.splitlines())) > 0
    "test_creation_allow_system_packages"
    # tomlkit 0.12 changes
    "test_no_strict_naming"
    "test_project_location_basic_set_first_project"
    "test_project_location_complex_set_first_project"
  ] ++ lib.optionals stdenv.isDarwin [
    # https://github.com/NixOS/nixpkgs/issues/209358
    "test_scripts_no_environment"

    # This test assumes it is running on macOS with a system shell on the PATH.
    # It is not possible to run it in a nix build using a /nix/store shell.
    # See https://github.com/pypa/hatch/pull/709 for the relevant code.
    "test_populate_default_popen_kwargs_executable"
  ];

  meta = with lib; {
    description = "Modern, extensible Python project manager";
    homepage = "https://hatch.pypa.io/latest/";
    changelog = "https://github.com/pypa/hatch/blob/hatch-v${version}/docs/history/hatch.md";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
