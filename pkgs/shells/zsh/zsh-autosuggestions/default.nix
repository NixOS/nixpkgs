{ stdenv, fetchFromGitHub, zsh }:

# To make use of this derivation, use the `programs.zsh.enableAutoSuggestions` option

stdenv.mkDerivation rec {
  name = "zsh-autosuggestions-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-autosuggestions";
    rev = "v${version}";
    sha256 = "0l5n4bjalz2nmbf50j56aq82r2lc784l21n3k5fx2khxckdb89p2";
  };

  buildInputs = [ zsh ];

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
