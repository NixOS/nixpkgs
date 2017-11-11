{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.1";
  name = "nix-bash-completions-${version}";

  src = fetchFromGitHub {
    owner = "hedning";
    repo = "nix-bash-completions";
    rev = "v${version}";
    sha256 = "1gb6fmnask1xmjv5j5x0jb505lyp0p4lx2kbibfnb2gi57wapxaz";
  };

  installPhase = ''
    mkdir -p $out/share/bash-completion/completions
    cp _* $out/share/bash-completion/completions
  '';

  meta = {
    homepage = http://github.com/hedning/nix-bash-completions;
    description = "Bash completions for Nix, NixOS, and NixOps";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ hedning ];
  };
}
