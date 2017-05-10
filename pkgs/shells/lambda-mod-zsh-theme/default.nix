{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "lambda-mod-zsh-theme-unstable-2017-04-05";

  src = fetchFromGitHub {
    owner = "halfo";
    repo = "lambda-mod-zsh-theme";
    sha256 = "01c77s6fagycin6cpssif56ysbqaa8kiafjn9av12cacakldl84j";
    rev = "c6445c79cbc73b85cc18871c216fb28ddc8b3d96";
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
