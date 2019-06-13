{ stdenv, fetchFromGitHub, cmake, pkgconfig
, glib, zlib, pcre, mysql, libressl }:

stdenv.mkDerivation rec {
  version = "0.9.5";
  name = "mydumper-${version}";

  src = fetchFromGitHub {
    owner  = "maxbube";
    repo   = "mydumper";
    rev    = "v${version}";
    sha256 = "0vbz0ri5hm6yzkrcgnaj8px6bf59myr5dbhyy7fd4cv44hr685k6";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ glib zlib pcre mysql.connector-c libressl ];

  meta = with stdenv.lib; {
    description = ''High-perfomance MySQL backup tool'';
    homepage = https://github.com/maxbube/mydumper;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
