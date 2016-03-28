{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "zsh-navigation-tools-${version}";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "psprint";
    repo = "zsh-navigation-tools";
    rev = "v${version}";
    sha256 = "1r24mpx57jyn201mdhd793rlhlr5r83n9137aafkgf86282ghr7y";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions/
    cp n-* $out/share/zsh/site-functions/
    cp znt-* $out/share/zsh/site-functions/
  '';

  meta = with stdenv.lib; {
    description = "Curses-based tools for ZSH";
    homepage = https://github.com/psprint/zsh-navigation-tools;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
