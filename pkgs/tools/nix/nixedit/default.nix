{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "nixedit";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "fndov";
    repo = "nixedit";
    rev = "main";
    sha256 = "1hmda40xcqdb5akbbafyhhkhnarn677fjvd264ki5pbz71lmlbfl";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  buildInputs = [
    pkgs.bash
    pkgs.fzf
    pkgs.jq
    pkgs.micro
    pkgs.git
    pkgs.nix-tree
    pkgs.coreutils
  ];

  installPhase = ''
    mkdir -p $out/bin

    # Copy the scripts
    cp src/nixedit.sh $out/bin/nixedit

    # Ensure they are executable
    chmod +x $out/bin/nixedit

    # Wrap nixedit to include the necessary dependencies in PATH
    wrapProgram $out/bin/nixedit --prefix PATH : \
      "${pkgs.bash}/bin:${pkgs.coreutils}/bin:${pkgs.nix-tree}/bin:${pkgs.jq}/bin:${pkgs.micro}/bin:${pkgs.git}/bin"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    if ! uname -a | grep "NixOS" > /dev/null; then
      echo "This package can only be installed on NixOS."
      exit 1
    fi

    $out/bin/nixedit --help 
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/fndov/nixedit";
    description = "A NixOS Multipurpose CLI/TUI Utility";
    license = licenses.gpl3;
    maintainers = with maintainers; [ miyu ];
  };
}
