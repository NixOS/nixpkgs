{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "lambda-mod-zsh-theme-unstable-2017-07-05";

  src = fetchFromGitHub {
    owner = "halfo";
    repo = "lambda-mod-zsh-theme";
    sha256 = "03kdhifxsnfbly6hqpr1h6kf52kyhdbh82nvwkkyrz1lw2cxl89n";
    rev = "ba7d5fea16db91fc8de887e69250f4e501b1e36d";
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
