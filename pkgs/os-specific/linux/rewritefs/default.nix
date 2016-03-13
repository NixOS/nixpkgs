{ stdenv, fetchFromGitHub, pkgconfig, fuse, pcre }: 

stdenv.mkDerivation rec {
  name = "rewritefs-${version}";
  version = "2016-02-08";

  src = fetchFromGitHub {
    owner = "sloonz";
    repo = "rewritefs";
    rev = "3ac0d1789bb9d48dbeddc6721d00eef19d1dc956";
    sha256 = "0bj8mq5hd52afmy01dyhqsx2rby7injhg96x9z3gyv0r90wa59bh";
  };
 
  buildInputs = [ pkgconfig fuse pcre ];

  preConfigure = "substituteInPlace Makefile --replace /usr/local $out";

  meta = with stdenv.lib; {
    description = ''A FUSE filesystem intended to be used
      like Apache mod_rewrite'';
    homepage    = "https://github.com/sloonz/rewritefs";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };
}
