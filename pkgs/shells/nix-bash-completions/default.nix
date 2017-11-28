{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.6";
  name = "nix-bash-completions-${version}";

  src = fetchFromGitHub {
    owner = "hedning";
    repo = "nix-bash-completions";
    rev = "v${version}";
    sha256 = "093rla6wwx51fclh7xm8qlssx70hj0fj23r59qalaaxf7fdzg2hf";
  };

  installPhase = ''
    mkdir -p $out/share/bash-completion/completions
    cp _nix $out/share/bash-completion/completions
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/hedning/nix-bash-completions;
    description = "Bash completions for Nix, NixOS, and NixOps";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ hedning ];
  };
}
