<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "3.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "b2";
    hash = "sha256-Z9LQapWl0zblcAyMOfKhn5/O1H6+tmgiPQfAB241jqU=";
=======
{ fetchFromGitHub, lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "3.7.0";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "b2";
    sha256 = "sha256-sW6gaZWUh3WX+0+qHRlQ4gZzKU4bL8ePPNKWo9rdF84=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'phx-class-registry==4.0.5' 'phx-class-registry'
    substituteInPlace requirements.txt \
      --replace 'tabulate==0.8.10' 'tabulate'
    substituteInPlace setup.py \
      --replace 'setuptools_scm<6.0' 'setuptools_scm'
  '';

<<<<<<< HEAD
  nativeBuildInputs = [
    installShellFiles
    python3Packages.setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    argcomplete
    arrow
=======
  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    b2sdk
    phx-class-registry
    setuptools
    docutils
    rst2ansi
    tabulate
<<<<<<< HEAD
    tqdm
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = with python3Packages; [
    backoff
    more-itertools
<<<<<<< HEAD
    pexpect
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # require network
    "test_files_headers"
    "test_integration"
<<<<<<< HEAD

    # fixed by https://github.com/Backblaze/B2_Command_Line_Tool/pull/915
    "TestRmConsoleTool"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTestPaths = [
    # requires network
    "test/integration/test_b2_command_line.py"
<<<<<<< HEAD

    # it's hard to make it work on nix
    "test/integration/test_autocomplete.py"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postInstall = ''
    mv "$out/bin/b2" "$out/bin/backblaze-b2"

<<<<<<< HEAD
    installShellCompletion --cmd backblaze-b2 \
      --bash <(${python3Packages.argcomplete}/bin/register-python-argcomplete backblaze-b2) \
      --zsh <(${python3Packages.argcomplete}/bin/register-python-argcomplete backblaze-b2)
=======
    sed 's/b2/backblaze-b2/' -i contrib/bash_completion/b2

    mkdir -p "$out/share/bash-completion/completions"
    cp contrib/bash_completion/b2 "$out/share/bash-completion/completions/backblaze-b2"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    homepage = "https://github.com/Backblaze/B2_Command_Line_Tool";
<<<<<<< HEAD
    changelog = "https://github.com/Backblaze/B2_Command_Line_Tool/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka kevincox tomhoule ];
  };
}
