{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, glib
, zlib
, pcre
, libmysqlclient
, libressl
}:

let inherit (lib) getDev; in

stdenv.mkDerivation rec {
  pname = "mydumper";
  version = "0.14.1-1";

  src = fetchFromGitHub {
    owner  = "maxbube";
    repo = "mydumper";
    rev = "refs/tags/v${version}";
    hash = "sha256-I8COArsIO8+09SNa3DrgoGpvhLj08I8UvT2H9k9mJNQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    zlib
    pcre
    libmysqlclient
    libressl
  ];

  cmakeFlags = [
    "-DMYSQL_INCLUDE_DIR=${getDev libmysqlclient}/include/mysql"
  ];

  meta = with lib; {
    description = "High-perfomance MySQL backup tool";
    homepage = "https://github.com/maxbube/mydumper";
    changelog = "https://github.com/mydumper/mydumper/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
