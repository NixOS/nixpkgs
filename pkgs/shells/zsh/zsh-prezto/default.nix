{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "2020-05-20";
  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "793f239a5e38ef2c4b76a4955bb734520303e8c4";
    sha256 = "0xhdl1g0rvlikq6qxh6cwp6wsrgmw4l1rmmq5xpc7wl6dyh35yri";
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
  meta = with stdenv.lib; {
    description = "Prezto is the configuration framework for Zsh; it enriches the command line interface environment with sane defaults, aliases, functions, auto completion, and prompt themes.";
    homepage = "https://github.com/sorin-ionescu/prezto";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}
