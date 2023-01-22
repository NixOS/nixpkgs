{ lib
, stdenv
, fetchFromGitHub
, python3
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hatch";
  version = "1.6.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "hatch";
    rev = "hatch-v${version}";
    hash = "sha256-3nPh6F+TmLoogz9FgaZMub7hPJIzANCY4oWk9Mq22Pc=";
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
  ];

  meta = with lib; {
    description = "Modern, extensible Python project manager";
    homepage = "https://hatch.pypa.io/latest/";
    changelog = "https://github.com/pypa/hatch/blob/${src.rev}/docs/history.md#hatch";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
