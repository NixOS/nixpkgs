{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  fzf,
  jq,
  micro,
  git,
  nix-tree,
  coreutils,
  makeWrapper,
  dialog,
}:

stdenv.mkDerivation {
  pname = "nixedit";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fndov";
    repo = "nixedit";
    rev = "75e7bab546c4946cd65079fdcad8bc2ab1550b8f";
    hash = "sha256-KpqdyE6TqDHCj2zQZw2F66ZmSI93Oy6LxmPa+DXGB1A=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    bash
    fzf
    jq
    micro
    git
    nix-tree
    coreutils
    dialog
  ];

  installPhase = ''
    mkdir -p $out/bin

    # Copy the scripts
    cp src/nixedit.sh $out/bin/nixedit

    # Ensure they are executable
    chmod +x $out/bin/nixedit

    # Wrap nixedit to include the necessary dependencies in PATH
    wrapProgram $out/bin/nixedit --prefix PATH : \
      "${
        lib.makeBinPath [
          bash
          coreutils
          nix-tree
          jq
          micro
          git
          fzf
          dialog
        ]
      }"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    if ! uname -a | grep "NixOS" > /dev/null; then
      echo "This package can only be installed on NixOS."
      exit 1
    fi

    $out/bin/nixedit --help > /dev/null
  '';

  meta = {
    homepage = "https://github.com/fndov/nixedit";
    description = "A NixOS Multipurpose CLI/TUI Utility";
    license = lib.licenses.gpl3;
    mainProgram = "nixedit";
    maintainers = with lib.maintainers; [ miyu ];
  };
}
