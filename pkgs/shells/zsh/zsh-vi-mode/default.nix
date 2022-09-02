{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-vi-mode";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "jeffreytse";
    repo = pname;
    rev = "v${version}";
    sha256 = "EOYqHh0rcgoi26eopm6FTl81ehak5kXMmzNcnJDH8/E=";
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
