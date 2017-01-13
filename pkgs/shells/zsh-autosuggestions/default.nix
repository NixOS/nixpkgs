{ stdenv, fetchFromGitHub, zsh }:

# To make use of this derivation, use the `programs.zsh.enableAutoSuggestions` option

stdenv.mkDerivation rec {
  name = "zsh-autosuggestions-${version}";
  version = "0.3.3";

  src = fetchFromGitHub {
    repo = "zsh-autosuggestions";
    owner = "zsh-users";
    rev = "v${version}";
    sha256 = "0mnwyz4byvckrslzqfng5c0cx8ka0y12zcy52kb7amg3l07jrls4";
  };

  buildInputs = [ zsh ];

  buildPhases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    install -D zsh-autosuggestions.zsh \
      $out/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';

  meta = with stdenv.lib; {
    description = "Fish shell autosuggestions for Zsh";
    homepage = "https://github.com/zsh-users/zsh-autosuggestions";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.loskutov ];
  };
}
