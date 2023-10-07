{ lib, stdenv, fetchFromGitHub, cmake, docutils, libev, openssl, systemd }:

stdenv.mkDerivation rec {
  pname = "pgagroal";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "agroal";
    repo = "pgagroal";
    rev = version;
    hash = "sha256-d6icEYlk0qnzmoP/mvSmTw16YfIYWc2WbY7sKguX7Ug=";
  };

  patches = [ ./do-not-search-libatomic.patch ];

  nativeBuildInputs = [ cmake docutils ];

  buildInputs = [ libev openssl systemd ];

  meta = with lib; {
    description = "High-performance connection pool for PostgreSQL";
    homepage = "https://agroal.github.io/pgagroal/";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.linux;
  };
}
