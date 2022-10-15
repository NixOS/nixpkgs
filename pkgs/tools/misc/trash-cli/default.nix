{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "trash-cli";
  version = "0.22.8.27";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = version;
    hash = "sha256-ym6Z1qZihqw7lIS1GXsExZK5hRsss/aqgMNldV8kUDk=";
  };

  propagatedBuildInputs = [ python3Packages.psutil ];

  checkInputs = with python3Packages; [
    mock
    pytestCheckHook
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # Create a home directory with a test file.
    HOME="$(mktemp -d)"
    touch "$HOME/deleteme"

    # Verify that trash list is initially empty.
    [[ $($out/bin/trash-list) == "" ]]

    # Trash a test file and verify that it shows up in the list.
    $out/bin/trash "$HOME/deleteme"
    [[ $($out/bin/trash-list) == *" $HOME/deleteme" ]]

    # Empty the trash and verify that it is empty.
    $out/bin/trash-empty
    [[ $($out/bin/trash-list) == "" ]]

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/andreafrancia/trash-cli";
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    mainProgram = "trash";
  };
}
