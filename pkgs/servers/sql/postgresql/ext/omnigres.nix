{
  buildEnv,
  bison,
  boost,
  brotli,
  bzip2,
  cmake,
  doxygen,
  fetchFromGitHub,
  flex,
  git,
  lib,
  libcap,
  libtool,
  libuv,
  libxml2,
  lld,
  netcat,
  openssl,
  perl,
  pkg-config,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
  postgresqlPackages,
  python3,
  readline,
  stdenv,
  zlib,
}:

let
  # TODO: I'll remove this as well, just testing stuff
  extensions =
    buildEnv {
      name = "postgresql-custom";
      paths = [ postgresql postgresqlPackages.plpython3 ];
    };
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
  buildInputs =
    postgresql.buildInputs ++ [
      bison
      boost
      brotli
      bzip2
      doxygen
      flex
      git
      libcap
      libuv
      libxml2
      lld
      netcat
      openssl
      perl
      python3
      readline
      zlib
      # TODO: just some hacky tests, remove this later
      extensions
    ];

  preConfigure = ''
    substituteInPlace cmake/PostgreSQLExtension.cmake \
      --replace "\''${_ext_dir}" "$out"
  '';

  cmakeFlags = [
     "-DCMAKE_BUILD_TYPE=Release"
     "-DPGVER=${postgresql.version}"
     "-DNETCAT=${netcat}/bin/nc"
     "-DOPENSSL_CONFIGURED=1"
     "-DPG_CONFIG=${postgresql.pg_config}/bin/pg_config"
     "-DPG_CTL=${postgresql}/bin/pg_ctl"
     "-DPSQL=${postgresql}/bin/psql"
     "-DCREATEDB=${postgresql}/bin/createdb"
     "-DINITDB=${postgresql}/bin/initdb"
     "-DPostgreSQL_LIBRARY_DIRS=${postgresql}/lib"
     "-DPostgreSQL_EXTENSION_DIR=${extensions}/share/postgresql/extension"
     "-DPostgreSQL_SERVER_INCLUDE_DIRS=${lib.getDev postgresql}/include"
     "-DPython3_EXECUTABLE=${python3}/bin/python3"
     "-DPython_EXECUTABLE=${python3}/bin/python3"
     "-DDOXYGEN_EXECUTABLE=${doxygen}/bin/doxygen"
  ];

  buildPhase = ''
    cmake -S . -B build
    make all
  '';

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    withPackages = [ "plpython3" "omnigres" ];
    sql = ''
      CREATE EXTENSION omni;
    '';
  };

  meta = {
    description = "Postgres as a Business Operating System";
    homepage = "https://docs.omnigres.org/";
    maintainers = with lib.maintainers; [ mtrsk ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
  };
})
