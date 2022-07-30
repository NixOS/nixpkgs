{ lib
, stdenv
, fetchFromGitHub
, buildPythonApplication
, colorama
, decorator
, psutil
, pyte
, six
, go
, mock
, pytestCheckHook
, pytest-mock
, runCommandLocal
}:

let self = buildPythonApplication rec {
  pname = "thefuck";
  version = "3.32";

  src = fetchFromGitHub {
    owner = "nvbn";
    repo = self.pname;
    rev = self.version;
    sha256 = "sha256-bRCy95owBJaxoyCNQF6gEENoxCkmorhyKzZgU1dQN6I=";
  };

  propagatedBuildInputs = [ colorama decorator psutil pyte six ];

  checkInputs = [ go mock pytestCheckHook pytest-mock ];

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

  passthru.mkShellPkg =
    { alias ? "fuck"
    , instantMode ? false
    , noConfirm ? false
    , recursive ? false
    }: runCommandLocal "thefuck-shellPkgs-${version}"
      {
        outputs = map (sh: "interactiveShellInit_${sh}")
          ([ "bash" "zsh" ] ++ lib.optional (!instantMode) "fish"); # instant mode does not support fish
      } ''
      ${self}/bin/thefuck --alias ${alias} \
        ${lib.optionalString instantMode "--enable-experimental-instant-mode"} \
        ${lib.optionalString recursive "-r"} \
        ${lib.optionalString noConfirm "--yes"} > out.sh
      for o in $outputs
      do
        cp out.sh ''${!o}
      done
    '';

  meta = with lib; {
    homepage = "https://github.com/nvbn/thefuck";
    description = "Magnificent app which corrects your previous console command";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}; in self
