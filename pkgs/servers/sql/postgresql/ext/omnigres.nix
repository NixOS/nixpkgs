{
  bison,
  boost,
  cmake,
  fetchFromGitHub,
  flex,
  git,
  lib,
  libtool,
  libxml2,
  lld,
  netcat,
  openssl,
  perl,
  pkg-config,
  postgresql,
  postgresqlBuildExtension,
  # TODO: enable this later
  # postgresqlTestExtension,
  python3,
  readline,
  stdenv,
  zlib,
  # Package options
  pg_version ? "17"
}:

let
  postgresqlPy = postgresql.override { pythonSupport = true; python3 = python3;};
in
postgresqlBuildExtension (finalAttrs: {
  pname = "omnigres";
  version = "74ab3167d32e47fec790bb54a979780f7f9f1a28";

  src = fetchFromGitHub {
    owner = "omnigres";
    repo = "omnigres";
    rev = finalAttrs.version;
    hash = "sha256-PuxfD4XJv6ZxD1LnF3OopY+m057eBT1ZvEfRSbbIyzQ=";
  };

  nativeBuildInputs = [ cmake flex libtool pkg-config ];
  buildInputs = [
    bison
    boost
    flex
    git
    libxml2
    lld
    netcat
    openssl
    perl
    postgresqlPy
    python3
    readline
    zlib
  ];

  cmakeFlags = [
     "-DCMAKE_BUILD_TYPE=Release"
     "-DNETCAT=${netcat}/bin/nc"
     "-DOPENSSL_CONFIGURED=1"
     "-DPG_CONFIG=${postgresql.pg_config}/bin/pg_config"
     "-DPG_CTL=${postgresql}/bin/pg_ctl"
     "-DPSQL=${postgresql}/bin/psql"
     "-DCREATEDB=${postgresql}/bin/createdb"
     "-DINITDB=${postgresql}/bin/initdb"
     "-DPostgreSQL_LIBRARY_DIRS=${postgresql}/lib"
     "-DPostgreSQL_EXTENSION_DIR=${postgresql}/share/postgresql/extension"
     "-DPostgreSQL_SERVER_INCLUDE_DIRS=${lib.getDev postgresql}/include"
     "-DPython3_EXECUTABLE=${python3}/bin/python3"
     "-DPython_EXECUTABLE=${python3}/bin/python3"
  ];

  buildPhase = ''
    cmake -S . -B build
    cmake --build build --parallel
  '';

  meta = {
    description = "Postgres as a Business Operating System.";
    homepage = "https://docs.omnigres.org/";
    maintainers = with lib.maintainers; [ mtrsk ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
  };
})
