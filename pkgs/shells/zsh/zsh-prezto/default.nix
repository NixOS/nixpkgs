{ lib, stdenv, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "unstable-2021-01-19";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "704fc46c3f83ca1055becce65fb513a533f48982";
    sha256 = "0rkbx6hllf6w6x64mggbhvm1fvbq5sr5kvf06sarfkpz5l0a5wh3";
    fetchSubmodules = true;
  };

  buildPhase = ''
    sed -i '/\''${ZDOTDIR:\-\$HOME}\/.zpreztorc" ]]/i\
    if [[ -s "/etc/zpreztorc" ]]; then\
      source "/etc/zpreztorc"\
    fi' init.zsh
    sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zprezto/|$out/|g" init.zsh
    for i in runcoms/*; do
      sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zprezto/|$out/|g" $i
    done
  '';

  installPhase = ''
    mkdir -p $out
    cp ./* $out/ -R
  '';

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "Prezto is the configuration framework for Zsh; it enriches the command line interface environment with sane defaults, aliases, functions, auto completion, and prompt themes";
    homepage = "https://github.com/sorin-ionescu/prezto";
    license = licenses.mit;
    maintainers = with maintainers; [ holymonson ];
    platforms = platforms.unix;
  };
}
