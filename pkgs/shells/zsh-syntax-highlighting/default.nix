{ stdenv, fetchFromGitHub, zsh }:

# To make use of this derivation, use the `programs.zsh.enableSyntaxHighlighting` option

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "zsh-syntax-highlighting-${version}";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-syntax-highlighting";
    rev = version;
    sha256 = "0k0m5aw67lhi4z143sdawx93y1892scvvdfdnjvljb4hf0vzs2ww";
  };

  buildInputs = [ zsh ];

  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Fish shell like syntax highlighting for Zsh";
    homepage = https://github.com/zsh-users/zsh-syntax-highlighting;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.loskutov ];
  };
}
