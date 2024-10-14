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

stdenv.mkDerivation (finalAttrs: {
  pname = "nixedit";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fndov";
    repo = "nixedit";
    rev = "d5fd24439917b0359529aee7d29da85f20608877";
    hash = "sha256-Xp7hMDjPuQyBZ535RHq5fI2r9iIeD8uC5LhHB+CB5sA=";
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
      "${lib.makeBinPath finalAttrs.buildInputs}"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    if ! uname -a | grep "NixOS" > /dev/null; then
      echo "This package can only be installed on NixOS."
      exit 1
    fi

    $out/bin/nixedit --help > /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/fndov/nixedit";
    description = "A NixOS Multipurpose CLI/TUI Utility";
    license = licenses.gpl3;
    mainProgram = "nixedit";
    maintainers = [ maintainers.miyu ];
  };
})
