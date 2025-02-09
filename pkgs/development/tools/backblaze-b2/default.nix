{ lib, python3Packages, fetchPypi, installShellFiles, testers, backblaze-b2 }:

python3Packages.buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "3.15.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "b2";
    hash = "sha256-10c2zddALy7+CGxhjUC6tMLQcZ3WmLeRY1bNKWunAys=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'phx-class-registry==4.0.5' 'phx-class-registry'
    substituteInPlace requirements.txt \
      --replace 'tabulate==0.8.10' 'tabulate'
    substituteInPlace setup.py \
      --replace 'setuptools_scm<6.0' 'setuptools_scm'
  '';

  nativeBuildInputs = [
    installShellFiles
    python3Packages.setuptools-scm
  ];

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
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # require network
    "test_files_headers"
    "test_integration"

    # fixed by https://github.com/Backblaze/B2_Command_Line_Tool/pull/915
    "TestRmConsoleTool"
  ];

  disabledTestPaths = [
    # requires network
    "test/integration/test_b2_command_line.py"

    # it's hard to make it work on nix
    "test/integration/test_autocomplete.py"
    "test/unit/console_tool"
  ];

  postInstall = ''
    mv "$out/bin/b2" "$out/bin/backblaze-b2"

    installShellCompletion --cmd backblaze-b2 \
      --bash <(${python3Packages.argcomplete}/bin/register-python-argcomplete backblaze-b2) \
      --zsh <(${python3Packages.argcomplete}/bin/register-python-argcomplete backblaze-b2)
  '';

  passthru.tests.version = (testers.testVersion {
    package = backblaze-b2;
    command = "backblaze-b2 version --short";
  }).overrideAttrs (old: {
    # workaround the error: Permission denied: '/homeless-shelter'
    # backblaze-b2 fails to create a 'b2' directory under the XDG config path
    HOME = "$(mktemp -d)";
  });

  meta = with lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    homepage = "https://github.com/Backblaze/B2_Command_Line_Tool";
    changelog = "https://github.com/Backblaze/B2_Command_Line_Tool/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka kevincox tomhoule ];
  };
}
