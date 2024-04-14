{ lib, stdenv, fetchFromGitHub, buildPythonApplication
, colorama, decorator, psutil, pyte, six
, go, mock, pytestCheckHook, pytest-mock, pytest_7
}:

buildPythonApplication rec {
  pname = "thefuck";
  version = "3.32";

  src = fetchFromGitHub {
    owner = "nvbn";
    repo = pname;
    rev = version;
    sha256 = "sha256-bRCy95owBJaxoyCNQF6gEENoxCkmorhyKzZgU1dQN6I=";
  };

  propagatedBuildInputs = [ colorama decorator psutil pyte six ];

  nativeCheckInputs = [ go mock (pytestCheckHook.override { pytest = pytest_7; }) pytest-mock ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_settings_defaults"
    "test_from_file"
    "test_from_env"
    "test_settings_from_args"
    "test_get_all_executables_exclude_paths"
    "test_with_blank_cache"
    "test_with_filled_cache"
    "test_when_etag_changed"
    "test_for_generic_shell"
    "test_on_first_run"
    "test_on_run_after_other_commands"
    "test_when_cant_configure_automatically"
    "test_when_already_configured"
    "test_when_successfully_configured"
  ];

  meta = with lib; {
    homepage = "https://github.com/nvbn/thefuck";
    description = "Magnificent app which corrects your previous console command";
    license = licenses.mit;
    maintainers = with maintainers; [ marcusramberg ];
  };
}
