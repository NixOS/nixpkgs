{ lib, stdenv, fetchFromGitHub, cmake
, curl, glib, sqlite, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.0.10";
  pname = "glyr";

  src = fetchFromGitHub {
    owner = "sahib";
    repo = "glyr";
    rev = version;
    sha256 = "1miwbqzkhg0v3zysrwh60pj9sv6ci4lzq2vq2hhc6pc6hdyh8xyr";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ sqlite glib curl ];

  meta = with lib; {
    description = "A music related metadata searchengine";
    homepage = "https://github.com/sahib/glyr";
    license = licenses.lgpl3;
    maintainers = [ maintainers.sternenseemann ];
    mainProgram = "glyrc";
    platforms = platforms.unix;
  };
}


