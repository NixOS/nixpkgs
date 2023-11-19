{ lib, python3Packages, fetchPypi, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "3.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "b2";
    hash = "sha256-Z9LQapWl0zblcAyMOfKhn5/O1H6+tmgiPQfAB241jqU=";
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
    setuptools
    docutils
    rst2ansi
    tabulate
    tqdm
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
  ];

  postInstall = ''
    mv "$out/bin/b2" "$out/bin/backblaze-b2"

    installShellCompletion --cmd backblaze-b2 \
      --bash <(${python3Packages.argcomplete}/bin/register-python-argcomplete backblaze-b2) \
      --zsh <(${python3Packages.argcomplete}/bin/register-python-argcomplete backblaze-b2)
  '';

  meta = with lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    homepage = "https://github.com/Backblaze/B2_Command_Line_Tool";
    changelog = "https://github.com/Backblaze/B2_Command_Line_Tool/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka kevincox tomhoule ];
  };
}
