{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "trash-cli";
  version = "0.23.2.13.2";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = version;
    hash = "sha256-TJEi7HKIrfOdb+LLRt2DN5gWdFzUeo6isb59lFLK4bQ=";
  };

  propagatedBuildInputs = with python3Packages; [ psutil six ];

  nativeCheckInputs = with python3Packages; [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    sed -i '/typing/d' setup.cfg
  '';

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
  postInstall = ''
    for bin in trash{,-{empty,list,put,restore}}; do
      $out/bin/$bin --print-completion bash > $bin
      install -Dm644 $bin -t $out/share/bash-completion/completions
      $out/bin/$bin --print-completion zsh > _$bin
      install -Dm644 _$bin -t $out/share/zsh/site-functions
      $out/bin/$bin --print-completion tcsh > $bin.csh
      install -Dm644 $bin.csh -t $out/etc/profile.d
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/andreafrancia/trash-cli";
    description = "Command line interface to the freedesktop.org trashcan";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    mainProgram = "trash";
  };
}
