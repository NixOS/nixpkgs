{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.2";
  name = "nix-bash-completions-${version}";

  src = fetchFromGitHub {
    owner = "hedning";
    repo = "nix-bash-completions";
    rev = "v${version}";
    sha256 = "0clr3c0zf73pnabab4n5b5x8cd2yilksvvlp4i0rj0cfbr1pzxgr";
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
