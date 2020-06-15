{ stdenv, libgit2, fetchgit }:

stdenv.mkDerivation rec {
  pname = "stagit-gopher";
  version = "0.9.3";

  src = fetchgit {
    url = "git://git.codemadness.org/stagit-gopher";
    rev = version;
    sha256 = "0dcyi3k900jb8p5qhgfk91gvplblysgfz1vyn6pqrlk931hpac80";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ libgit2 ];

  meta = with stdenv.lib; {
    homepage = "https://git.codemadness.org/stagit-gopher/file/README.html";
    description = "Static git site generator for gopher";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ hcssmith ];
  };
}
