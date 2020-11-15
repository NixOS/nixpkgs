{ stdenv, fetchFromGitHub, cmake
, curl, glib, sqlite, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.0.10";
  pname = "glyr";

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "glyr";
    rev = version;
    sha256 = "1miwbqzkhg0v3zysrwh60pj9sv6ci4lzq2vq2hhc6pc6hdyh8xyr";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ sqlite glib curl ];

  meta = with stdenv.lib; {
    license = licenses.lgpl3;
    description = "A music related metadata searchengine";
    homepage = "https://github.com/sahib/glyr";
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}


