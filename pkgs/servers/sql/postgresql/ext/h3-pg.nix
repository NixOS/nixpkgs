{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  h3_4,
  postgresql,
  postgresqlTestExtension,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension (finalAttrs: {
  pname = "h3-pg";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "zachasme";
    repo = "h3-pg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uZ4XI/VXRr636CI1r24D6ykPQqO5qZNxNQLUQKmoPtg=";
  };

  postPatch =
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "add_subdirectory(cmake/h3)" "include_directories(${lib.getDev h3_4}/include/h3)"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace cmake/AddPostgreSQLExtension.cmake \
        --replace-fail "INTERPROCEDURAL_OPTIMIZATION TRUE" ""
      # Commented upstream: https://github.com/zachasme/h3-pg/pull/141/files#r1844970927
      substituteInPlace cmake/FindPostgreSQL.cmake \
        --replace-fail 'list(APPEND PostgreSQL_INCLUDE_DIRS "/usr/local/include")' ""
    '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    h3_4
  ];

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
