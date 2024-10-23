{
  lib,
  fetchFromGitHub,
  stdenv,
  sqlite,
  postgresql,
}:

stdenv.mkDerivation {
  pname = "sqlite_fdw";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "pgspider";
    repo = "sqlite_fdw";
    rev = "v2.4.0";
    hash = "sha256-u51rcKUH2nZyZbI2g3crzHt5jiacbTq4xmfP3JgqnnM=";
  };

  buildInputs = [
    sqlite
    postgresql
  ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    mkdir -p $out/lib $out/share/postgresql/extension
    mv *.so $out/lib
    mv *.sql *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "SQLite Foreign Data Wrapper for PostgreSQL";
    homepage = "https://github.com/pgspider/sqlite_fdw";
    maintainers = with maintainers; [ apfelkuchen6 ];
    platforms = platforms.unix;
    license = licenses.postgresql;
  };
}
