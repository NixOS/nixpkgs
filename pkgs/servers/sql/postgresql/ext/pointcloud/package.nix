{
  autoconf,
  automake,
  cunit,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  lib,
  libtool,
  libxml2,
  perl,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
  postgresqlTestHook,
  sphinx,
  which,
  zlib,
}:
postgresqlBuildExtension (finalAttrs: {
  pname = "pointcloud";
  version = "1.2.5";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "pgpointcloud";
    repo = "pointcloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uFbScxq21kt0jOjjyfMeO3i+bG2/kWS/Rrt3ZpOqEns=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    installShellFiles
    libtool
    perl
    # for doc
    sphinx
    # needed by the configure phase
    which
  ];

  buildInputs = [
    zlib
  ];

  doCheck = !(postgresqlTestHook.meta.broken);

  checkInputs = [
    cunit
  ];

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [
    (lib.withFeatureAs true "xml2config" (lib.getExe' (lib.getDev libxml2) "xml2-config"))
  ];

  postInstall = ''
    cd doc
    make man
    installManPage build/man/pgpointcloud.1
  '';

  passthru.tests = {
    extension = postgresqlTestExtension {
      inherit (finalAttrs) finalPackage;
      # see https://pgpointcloud.github.io/pointcloud/concepts/schemas.html
      withPackages = [ "postgis" ];
      sql = builtins.readFile ./tests.sql;
      asserts = [
        {
          query = "pc_version()";
          expected = "'${lib.versions.major finalAttrs.version}.${lib.versions.minor finalAttrs.version}.${lib.versions.patch finalAttrs.version}'";
          description = "pc_version() returns correct values.";
        }
        {
          query = "pc_postgis_version()";
          expected = "'${lib.versions.major finalAttrs.version}.${lib.versions.minor finalAttrs.version}.${lib.versions.patch finalAttrs.version}'";
          description = "pc_postgis_version() returns correct values.";
        }
        # these tests are taken from the documentation of respective methods
        {
          query = "SELECT PC_AsText('010100000064CEFFFF94110000703000000400'::pcpoint)";
          expected = "'{\"pcid\":1,\"pt\":[-127,45,124,4]}'";
          description = "Creating a point and displaying as text returns correct string";
        }
        {
          query = "SELECT ST_AsText(PC_MakePoint(1, ARRAY[-127, 45, 124.0, 4.0])::geometry)";
          expected = "'POINT Z (-127 45 124)'";
          description = "Casting a pcpoint to a postgis geometry works";
        }
      ];
    };
  };

  meta = {
    description = "PostgreSQL extension for storing point cloud (LIDAR) data";
    longDescription = ''
      # pgPointcloud - A PostgreSQL extension for storing point cloud (LIDAR) data.

      LIDAR point cloud are becoming more and more available. Devices are easy to get, not too expensive, and provide very accurate 3D points. pgPointCLoud is an open source PostgreSQL extension for storing point cloud data and use it with PostGIS. It is very easy to use, robust and efficient.

      By storing LIDAR points in a PostgreSQL database, pgPointcloud eases many problems and allows a good integration with other geo-spatial data (vector, raster) into one common framework : PostGIS.
    '';
    homepage = "https://pgpointcloud.github.io/pointcloud/";
    changelog = "https://github.com/pgpointcloud/pointcloud/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
    inherit (postgresql.meta) platforms;
  };
})
