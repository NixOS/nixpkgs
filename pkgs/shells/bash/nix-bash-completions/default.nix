{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.6.6";
  name = "nix-bash-completions-${version}";

  src = fetchFromGitHub {
    owner = "hedning";
    repo = "nix-bash-completions";
    rev = "v${version}";
    sha256 = "1lz9cgacyd4cphr7l90x4hn0ifhxwzz2d5829w1jcglasfacfpsw";
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
