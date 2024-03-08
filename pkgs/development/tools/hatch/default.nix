{ lib
, stdenv
, fetchPypi
, python3
, cargo
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hatch";
  version = "1.9.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4ealEeFS7HzU26vE9Pahh0hwvUnJfRfTkLkjLdpoXOM=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    hatchling
    httpx
    hyperlink
    keyring
    packaging
    pexpect
    platformdirs
    rich
    shellingham
    tomli-w
    tomlkit
    userpath
    virtualenv
    zstandard
  ];

  nativeCheckInputs = [
    cargo
  ] ++ (with python3.pkgs; [
    binary
    git
    pytestCheckHook
    pytest-mock
    pytest-xdist
    setuptools
  ]);

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
    # cli table output mismatch
    "test_context_formatting"
    # expects sh, finds bash
    "test_all"
    "test_already_installed_update_flag"
    "test_already_installed_update_prompt"
    # unmet expectations about the binary module we provide
    "test_dependency_not_found"
    "test_marker_unmet"
    # output capturing mismatch, likely stdout/stderr mixup
    "test_no_compatibility_check_if_exists"
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
