{ stdenv, fetchFromGitHub, zsh }:

# To make use of this derivation, use the `programs.zsh.enableSyntaxHighlighting` option

stdenv.mkDerivation rec {
  version = "0.6.0";
  pname = "zsh-syntax-highlighting";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-syntax-highlighting";
    rev = version;
    sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
  };

  buildInputs = [ zsh ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Fish shell like syntax highlighting for Zsh";
    homepage = https://github.com/zsh-users/zsh-syntax-highlighting;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.loskutov ];
  };
}
