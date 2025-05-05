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
  python3Packages,
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
  version = "413feff21f9f7310023d8cfd92b83f2a251b1aa4";

  src = fetchFromGitHub {
    owner = "omnigres";
    repo = "omnigres";
    rev = finalAttrs.version;
    hash = "sha256-OEKXz/98VpaBhLhC2mkWx73lQmlflv3sI7eXLvgoDiI=";
  };

  nativeBuildInputs = [ cmake flex libtool pkg-config perl ];
  propagatedBuildInputs = [
    python3
    python3Packages.build
  ];
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
      python3Packages.build
      readline
      zlib
      # TODO: just some hacky tests, remove this later
      extensions
    ];

  cmakeFlags = [
     "-DCMAKE_BUILD_TYPE=Release"
     "-DNETCAT=${netcat}/bin/nc"
     "-DOPENSSL_CONFIGURED=1"
     "-DPG_CONFIG=${postgresql.pg_config}/bin/pg_config"
     # Can remove this later after hack is deprecated
     "-DPostgreSQL_EXTENSION_DIR=${extensions}/share/postgresql/extension"
     "-DPostgreSQL_PACKAGE_LIBRARY_DIR=$out/share/postgresql/extension"
     "-DPython3_EXECUTABLE=${python3}/bin/python3"
     "-DPython_EXECUTABLE=${python3}/bin/python3"
     "-DDOXYGEN_EXECUTABLE=${doxygen}/bin/doxygen"
  ];

  enableParallelBuilding = true;

  # https://github.com/omnigres/omnigres?tab=readme-ov-file#building--using-extensions
  installPhase = ''
    mkdir -p $out/share/postgresql/extension
    cmake --build . --parallel --target package_extensions
    cmake --build . --parallel --target install_extensions
  '';

  #passthru.tests.extension = postgresqlTestExtension {
  #  inherit (finalAttrs) finalPackage;
  #  withPackages = [ "plpython3" "omnigres" ];
  #  sql = ''
  #    CREATE EXTENSION omni;
  #  '';
  #};

  meta = {
    description = "Postgres as a Business Operating System";
    homepage = "https://docs.omnigres.org/";
    maintainers = with lib.maintainers; [ mtrsk ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
  };
})
