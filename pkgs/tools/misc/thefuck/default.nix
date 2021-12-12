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

let self = buildPythonApplication {
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

  disabledTests = lib.optional stdenv.isDarwin [
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

  passthru.mkShellPkg = let shells = [ "bash" "fish" "zsh" ]; in
    { alias ? "fuck"
    , instantMode ? false
    , noConfirm ? false
    , recursive ? false
    }: runCommandLocal "thefuck-shellPkgs-${self.version}"
      {
        outputs = map (sh: "interactiveShellInit_${sh}") self.shells;
      } ''
      ${self}/bin/thefuck --alias ${alias} \
        ${lib.optionalString instantMode "--enable-experimental-instant-mode"} \
        ${lib.optionalString recursive "-r"} \
        ${lib.optionalString noConfirm "--yes"} > out.sh
      ${lib.concatMapStrings (sh:"cp out.sh $interactiveShellInit_${sh};") shells}
    '';

  meta = with lib; {
    homepage = "https://github.com/nvbn/thefuck";
    description = "Magnificent app which corrects your previous console command";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}; in self
