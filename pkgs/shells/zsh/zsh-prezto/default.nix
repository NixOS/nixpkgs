{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "zsh-prezto-2019-03-18";
  src = fetchgit {
    url = "https://github.com/sorin-ionescu/prezto";
    rev = "1f4601e44c989b90dc7314b151891fa60a101251";
    sha256 = "1dcd5r7pc4biiplm0lh7yca0h6hs0xpaq9dwaarmfsh9wrd68350";
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
    homepage = https://github.com/sorin-ionescu/prezto;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
    platforms = with platforms; unix;
  };
}
