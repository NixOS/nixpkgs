{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.6.4";
  name = "nix-bash-completions-${version}";

  src = fetchFromGitHub {
    owner = "hedning";
    repo = "nix-bash-completions";
    rev = "v${version}";
    sha256 = "1kdysrfc8dx24q438wj3aisn64g2w5yb6mx91qa385p5hz7b1yz2";
  };

  # To enable lazy loading via. bash-completion we need a symlink to the script
  # from every command name.
  installPhase = ''
    commands=$(
      function complete() { shift 2; echo "$@"; }
      shopt -s extglob
      source _nix
    )
    install -Dm444 -t $out/share/bash-completion/completions _nix
    cd $out/share/bash-completion/completions
    for c in $commands; do
      ln -s _nix $c
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/hedning/nix-bash-completions;
    description = "Bash completions for Nix, NixOS, and NixOps";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ hedning ];
  };
}
