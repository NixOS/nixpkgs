{ stdenv, fetchgit, libressl }:

stdenv.mkDerivation rec {

  pname = "geomyidae";
  version = "0.34";

  src = fetchgit {
    url = "git://bitreich.org/geomyidae";
    rev = version;
    sha256 = "0sbfc7s7575jgsgn6q9fn63j1k2vw0w52k6bixx4f7cyx0sj2p94";
  };

  buildInputs = [ libressl ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A gopher daemon for Linux/BSD";
    homepage = "gopher://bitreich.org/1/scm/geomyidae";
    license = licenses.mit;
    maintainers = [ maintainers.solene ];
    platforms = platforms.unix;
  };
}
