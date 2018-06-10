{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "lambda-mod-zsh-theme-unstable-2017-10-08";

  src = fetchFromGitHub {
    owner = "halfo";
    repo = "lambda-mod-zsh-theme";
    sha256 = "13yis07zyr192s0x2h04k5bm1yzbk5m3js83aa17xh5573w4b786";
    rev = "61c373c8aa5556d51522290b82ad44e7166bced1";
  };

  installPhase = ''
    mkdir -p $out/share/themes
    cp lambda-mod.zsh-theme $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "A ZSH theme optimized for people who use Git & Unicode-compatible fonts and terminals";
    homepage = https://github.com/halfo/lambda-mod-zsh-theme/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
