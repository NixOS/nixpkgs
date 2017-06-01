{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "lambda-mod-zsh-theme-unstable-2017-05-21";

  src = fetchFromGitHub {
    owner = "halfo";
    repo = "lambda-mod-zsh-theme";
    sha256 = "1410ryc22i20na5ypa1q6f106lkjj8n1qfjmb77q4rspi0ydaiy4";
    rev = "6fa277361ec2c84e612b5b6d876797ebe72102a5";
  };

  buildPhases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp lambda-mod.zsh-theme $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "A ZSH theme optimized for people who use Git & Unicode-compatible fonts and terminals";
    homepage = "https://github.com/halfo/lambda-mod-zsh-theme/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
