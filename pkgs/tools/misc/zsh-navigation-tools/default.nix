{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "zsh-navigation-tools-${version}";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "psprint";
    repo = "zsh-navigation-tools";
    rev = "v${version}";
    sha256 = "0rfab3maha366dgvcmiqj6049wk5fynns1ygbgy4gnvavx2acvg2";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions/
    cp zsh-navigation-tools.plugin.zsh $out/share/zsh/site-functions/
    cp n-* $out/share/zsh/site-functions/
    cp znt-* $out/share/zsh/site-functions/
    mkdir -p $out/share/zsh/site-functions/.config/znt
    cp .config/znt/n-* $out/share/zsh/site-functions/.config/znt
  '';

  meta = with stdenv.lib; {
    description = "Curses-based tools for ZSH";
    homepage = https://github.com/psprint/zsh-navigation-tools;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
