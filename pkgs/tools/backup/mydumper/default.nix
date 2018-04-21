{ stdenv, fetchFromGitHub, cmake, pkgconfig
, glib, zlib, pcre, mysql, libressl }:

stdenv.mkDerivation rec {
  version = "0.9.3";
  name = "mydumper-${version}";

  src = fetchFromGitHub {
    owner  = "maxbube";
    repo   = "mydumper";
    rev    = "v${version}";
    sha256 = "139v6707sxyslg7n1fii8b1ybdq50hbqhc8zf6p1cr3h2hhl6ns9";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ glib zlib pcre mysql.connector-c libressl ];

  meta = with stdenv.lib; {
    description = ''High-perfomance MySQL backup tool'';
    homepage = https://github.com/maxbube/mydumper;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}
