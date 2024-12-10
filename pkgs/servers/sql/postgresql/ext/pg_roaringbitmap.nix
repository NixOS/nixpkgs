{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  postgresqlTestHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pg_roaringbitmap";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "ChenHuajun";
    repo = "pg_roaringbitmap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E6vqawnsRsAIajGDgJcTUWV1H8GFFboTjhmVfemUGbs=";
  };

  buildInputs = [
    postgresql
  ];

  installPhase = ''
    install -D -t $out/lib roaringbitmap${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension roaringbitmap-*.sql
    install -D -t $out/share/postgresql/extension roaringbitmap.control
  '';

  meta = with lib; {
    description = "RoaringBitmap extension for PostgreSQL";
    homepage = "https://github.com/ChenHuajun/pg_roaringbitmap";
    changelog = "https://github.com/ChenHuajun/pg_roaringbitmap/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
    inherit (postgresql.meta) platforms;
  };
})
