{ lib, fetchFromGitHub, stdenv, pcre2, boost, zlib, lzham }:

stdenv.mkDerivation rec {
  pname = "ugrep";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = pname;
    rev = "v${version}";
    sha256 = "16nr7zq4l2si9pfckfinbqnv94hw51z2qcbygc9x81jbjlvg3003";
  };

  buildInputs = [ pcre2 boost zlib lzham ];

  meta = with stdenv.lib; {
    description = "Ultra fast grep with interactive query UI";
    homepage = "https://github.com/Genivia/ugrep";
    maintainers = with maintainers; [ numkem ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
