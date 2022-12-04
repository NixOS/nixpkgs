{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, glib, zlib, pcre, libmysqlclient, libressl }:

let inherit (lib) getDev; in

stdenv.mkDerivation rec {
  version = "0.13.1-1";
  pname = "mydumper";

  src = fetchFromGitHub {
    owner  = "maxbube";
    repo   = "mydumper";
    rev    = "v${version}";
    sha256 = "sha256-Oknivkyr3wOfjnDccEeFVt7D2l1CkeWgXahsQCtAc0I=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ glib zlib pcre libmysqlclient libressl ];

  cmakeFlags = [ "-DMYSQL_INCLUDE_DIR=${getDev libmysqlclient}/include/mysql" ];

  meta = with lib; {
    description = "High-perfomance MySQL backup tool";
    homepage = "https://github.com/maxbube/mydumper";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
