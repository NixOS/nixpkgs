{ stdenv, fetchFromGitHub, zsh }:

# To make use of this derivation, use the `programs.zsh.enableAutoSuggestions` option

stdenv.mkDerivation rec {
  name = "zsh-autosuggestions-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-autosuggestions";
    rev = "v${version}";
    sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
  };

  buildInputs = [ zsh ];

  buildPhases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    install -D zsh-autosuggestions.zsh \
      $out/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';

  meta = with stdenv.lib; {
    description = "Fish shell autosuggestions for Zsh";
    homepage = https://github.com/zsh-users/zsh-autosuggestions;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.loskutov ];
  };
}
