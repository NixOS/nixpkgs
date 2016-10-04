{ stdenv, fetchFromGitHub, pkgconfig, fuse, pcre }: 

stdenv.mkDerivation rec {
  name = "rewritefs-${version}";
  version = "2016-07-27";

  src = fetchFromGitHub {
    owner = "sloonz";
    repo = "rewritefs";
    rev = "fe19d389746bdffcc1cc7b3e3156dbacd04b4e9b";
    sha256 = "15bcxprkxf0xqxljsqhb0jpi7p1vwqcb00sjs7nzrj7vh2p7mqla";
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
