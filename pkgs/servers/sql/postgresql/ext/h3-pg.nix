{ lib
, stdenv
, cmake
, fetchFromGitHub
, h3_4
, postgresql
, postgresqlTestHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "h3-pg";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "zachasme";
    repo = "h3-pg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nkaDZ+JuMtsGUJVx70DD2coLrmc/T8/cNov7pfNF1Eg=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(cmake/h3)" "include_directories(${lib.getDev h3_4}/include/h3)"
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace cmake/AddPostgreSQLExtension.cmake \
      --replace "INTERPROCEDURAL_OPTIMIZATION TRUE" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    h3_4
    postgresql
  ];

  installPhase = ''
    install -D -t $out/lib h3/h3.so
    install -D -t $out/share/postgresql/extension h3/h3-*.sql h3/h3.control
    install -D -t $out/lib h3_postgis/h3_postgis.so
    install -D -t $out/share/postgresql/extension h3_postgis/h3_postgis-*.sql h3_postgis/h3_postgis.control
  '';

  passthru.tests.extension = stdenv.mkDerivation {
    name = "h3-pg-test";
    dontUnpack = true;
    doCheck = true;
    buildInputs = [ postgresqlTestHook ];
    nativeCheckInputs = [ (postgresql.withPackages (ps: [ ps.h3-pg ps.postgis ])) ];
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    passAsFile = [ "sql" ];
    sql = ''
      CREATE EXTENSION h3;
      CREATE EXTENSION h3_postgis CASCADE;

      SELECT h3_lat_lng_to_cell(POINT('37.3615593,-122.0553238'), 5);
      SELECT ST_NPoints(h3_cell_to_boundary_geometry('8a63a9a99047fff'));
    '';
    failureHook = "postgresqlStop";
    checkPhase = ''
      runHook preCheck
      psql -a -v ON_ERROR_STOP=1 -f $sqlPath
      runHook postCheck
    '';
    installPhase = "touch $out";
  };

  meta = with lib; {
    description = "PostgreSQL bindings for H3, a hierarchical hexagonal geospatial indexing system";
    homepage = "https://github.com/zachasme/h3-pg";
    license = licenses.asl20;
    maintainers = [ ];
    inherit (postgresql.meta) platforms;
  };
})
