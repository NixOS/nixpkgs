{
  lib,
  fetchFromGitHub,
  gmp,
  postgresql,
  postgresqlBuildExtension,
  python3,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgmp";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "dvarrazzo";
    repo = "pgmp";
    tag = "rel-${finalAttrs.version}";
    hash = "sha256-D0zdDXFf8XJkRKOvxGuhy/sWAWoEquRmYv1wnD3Vz+I=";
  };

  nativeBuildInputs = [ python3 ];
  buildInputs = [ gmp ];

  # The extension's install scripts are generated from its sources.
  preBuild = ''
    python3 tools/unmix.py < sql/pgmp.pysql > sql/pgmp--1.1.sql
    python3 tools/sql2extension.py --extname pgmp sql/pgmp--1.1.sql > sql/pgmp--unpackaged--1.1.sql
  '';
  makeFlags = [ "with_llvm=no" ];

  meta = {
    description = "Arbitrary precision integers and rationals for PostgreSQL";
    homepage = "https://github.com/dvarrazzo/pgmp";
    changelog = "https://github.com/dvarrazzo/pgmp/blob/rel-${finalAttrs.version}/docs/news.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ athanclark ];
    platforms = postgresql.meta.platforms;
  };
})
