{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.5";
  name = "nix-bash-completions-${version}";

  src = fetchFromGitHub {
    owner = "hedning";
    repo = "nix-bash-completions";
    rev = "v${version}";
    sha256 = "095dbbqssaxf0y85xw73gajif6lzy2aja4scg3plplng3k9zbldz";
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
