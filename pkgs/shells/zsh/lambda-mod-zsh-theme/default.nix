{ stdenv, fetchFromGitHub, zsh }:

stdenv.mkDerivation {
  name = "lambda-mod-zsh-theme-unstable-2019-04-17";

  src = fetchFromGitHub {
    owner = "halfo";
    repo = "lambda-mod-zsh-theme";
    rev = "6b83aedf9de41ea4e226cdbc78af1b7b92beb6ac";
    sha256 = "1xf451c349fxnqbvsb07y9r1iqrwslx6x4b6drmnqqqy4yx1r5dj";
  };

  buildInputs = [ zsh ];

  installPhase = ''
    chmod +x lambda-mod.zsh-theme # only executable scripts are found by `patchShebangs`
    patchShebangs .

    install -Dm0644 lambda-mod.zsh-theme $out/share/zsh/themes/lambda-mod.zsh-theme
  '';

  meta = with stdenv.lib; {
    description = "A ZSH theme optimized for people who use Git & Unicode-compatible fonts and terminals";
    homepage = https://github.com/halfo/lambda-mod-zsh-theme/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
