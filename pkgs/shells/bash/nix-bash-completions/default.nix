{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.6.7";
  pname = "nix-bash-completions";

  src = fetchFromGitHub {
    owner = "hedning";
    repo = "nix-bash-completions";
    rev = "v${version}";
    sha256 = "067j1gavpm9zv3vzw9gq0bi3bi0rjrijwprc1j016g44kvpq49qi";
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
