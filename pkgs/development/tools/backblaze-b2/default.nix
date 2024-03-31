{ lib
, python3Packages
, fetchFromGitHub
, installShellFiles
, testers
, backblaze-b2
# executable is renamed to backblaze-b2 by default, to avoid collision with boost's 'b2'
, execName ? "backblaze-b2"
}:

python3Packages.buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "3.17.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "v${version}";
    hash = "sha256-Xj7RNe6XM2atijhVasILWRdTzu6xuKBzMllM1z1mFLY=";
  };

  nativeBuildInputs = [
    installShellFiles
  ] ++ (with python3Packages; [
    pdm-backend
  ]);

  propagatedBuildInputs = with python3Packages; [
    argcomplete
    arrow
    b2sdk
    phx-class-registry
    docutils
    rst2ansi
    tabulate
    tqdm
    platformdirs
    packaging
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    backoff
    more-itertools
    pexpect
    pytestCheckHook
    pytest-xdist
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # requires network
    "test/integration/test_b2_command_line.py"
    "test/integration/test_tqdm_closer.py"

    # it's hard to make it work on nix
    "test/integration/test_autocomplete.py"
    "test/unit/test_console_tool.py"
    # this one causes successive tests to fail
    "test/unit/_cli/test_autocomplete_cache.py"
  ];

  postInstall = lib.optionalString (execName != "b2") ''
    mv "$out/bin/b2" "$out/bin/${execName}"
  ''
  + ''
    installShellCompletion --cmd ${execName} \
      --bash <(${python3Packages.argcomplete}/bin/register-python-argcomplete ${execName}) \
      --zsh <(${python3Packages.argcomplete}/bin/register-python-argcomplete ${execName})
  '';

  passthru.tests.version = (testers.testVersion {
    package = backblaze-b2;
    command = "${execName} version --short";
  }).overrideAttrs (old: {
    # workaround the error: Permission denied: '/homeless-shelter'
    # backblaze-b2 fails to create a 'b2' directory under the XDG config path
    preHook = ''
      export HOME=$(mktemp -d)
    '';
  });

  meta = with lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    mainProgram = "backblaze-b2";
    homepage = "https://github.com/Backblaze/B2_Command_Line_Tool";
    changelog = "https://github.com/Backblaze/B2_Command_Line_Tool/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka tomhoule ];
  };
}
