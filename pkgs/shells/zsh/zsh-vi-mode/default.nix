{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-vi-mode";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "jeffreytse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QE6ZwwM2X0aPqNnbVrj0y7w9hmuRf0H1j8nXYwyoLo4=";
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/${pname}
    cp *.zsh $out/share/${pname}/
  '';

  meta = with lib; {
    homepage = "https://github.com/jeffreytse/zsh-vi-mode";
    license = licenses.mit;
    description = "A better and friendly vi(vim) mode plugin for ZSH.";
    maintainers = with maintainers; [ kyleondy ];
  };
}
