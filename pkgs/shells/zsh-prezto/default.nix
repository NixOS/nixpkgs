{ stdenv, fetchpatch, fetchgit, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "zsh-prezto-2017-12-03";
  src = fetchgit {
    url = "https://github.com/sorin-ionescu/prezto";
    rev = "029414581e54f5b63156f81acd0d377e8eb78883";
    sha256 = "0crrj2nq0wcv5in8qimnkca2an760aqald13vq09s5kbwwc9rs1f";
    fetchSubmodules = true;
  };
  buildPhase = ''
    sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zpreztorc|/etc/zpreztorc|g" init.zsh
    sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zprezto/|$out/|g" init.zsh
    for i in runcoms/*; do
      sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zprezto/|$out/|g" $i
    done
    sed -i -e "s|\''${0:h}/cache.zsh|\''${ZDOTDIR:\-\$HOME}/.zfasd_cache|g" modules/fasd/init.zsh
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
