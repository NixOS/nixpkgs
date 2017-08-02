{ stdenv, fetchurl, fetchgit, fetchFromGitHub }:

let
  # https://github.com/spwhitt/nix-zsh-completions/pull/2
  nix-zsh-completions = fetchFromGitHub {
    owner = "garbas";
    repo = "nix-zsh-completions";
    rev = "9b7d216ec095ccee541ebfa5f04249aa2964d054";
    sha256 = "1pvmfcqdvdi3nc1jm72f54mwf06yrmlq31pqw6b5fczawcz02jrz";
  };
in stdenv.mkDerivation rec {
  rev = "4f19700919c8ebbaf75755fc0d03716d13183f49";
  name = "zsh-prezto-2015-03-03_rev${builtins.substring 0 7 rev}";
  src = fetchgit {
    url = "https://github.com/sorin-ionescu/prezto";
    inherit rev;
    sha256 = "17mql9mb7zbf8q1nvnci60yrmz5bl9q964i8dv4shz8b42861cdg";
    fetchSubmodules = true;
  };
  patches = [
    (fetchurl {
      url = "https://github.com/sorin-ionescu/prezto/pull/1028.patch";
      sha256 = "0n2s7kfp9ljrq8lw5iibv0vyv66awrkzkqbyvy7hlcl06d8aykjv";
    })
  ];
  buildPhase = ''
    sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zpreztorc|/etc/zpreztorc|g" init.zsh
    sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zprezto/|$out/|g" init.zsh
    for i in runcoms/*; do
      sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zprezto/|$out/|g" $i
    done
    sed -i -e "s|\''${0:h}/cache.zsh|\''${ZDOTDIR:\-\$HOME}/.zfasd_cache|g" modules/fasd/init.zsh
  '';
  installPhase = ''
    mkdir -p $out/modules/nix
    cp ${nix-zsh-completions}/* $out/modules/nix -R
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
