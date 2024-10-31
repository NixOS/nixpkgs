{ lib
, stdenv
, cmake
, fetchFromGitHub
, h3_4
, postgresql
, postgresqlTestExtension
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
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
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

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    withPackages = [ "postgis" ];
    sql = ''
      CREATE EXTENSION h3;
      CREATE EXTENSION h3_postgis CASCADE;

      SELECT h3_lat_lng_to_cell(POINT('37.3615593,-122.0553238'), 5);
      SELECT ST_NPoints(h3_cell_to_boundary_geometry('8a63a9a99047fff'));
    '';
  };

  meta = with lib; {
    description = "PostgreSQL bindings for H3, a hierarchical hexagonal geospatial indexing system";
    homepage = "https://github.com/zachasme/h3-pg";
    license = licenses.asl20;
    maintainers = [ ];
    inherit (postgresql.meta) platforms;
  };
})
