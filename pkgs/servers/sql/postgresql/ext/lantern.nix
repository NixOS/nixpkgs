{
  cmake,
  fetchFromGitHub,
  lib,
  openssl,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "postgresql-lantern";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lanterndata";
    repo = "lantern";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IsDD/um5pVvbzin8onf45DQVszl+Id/pJSQ2iijgHmg=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs --build lantern_hnsw/scripts/link_llvm_objects.sh
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openssl
  ];

  cmakeFlags = [
    "-DBUILD_FOR_DISTRIBUTING=ON"
    "-S ../lantern_hnsw"
  ];

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    sql = ''
      CREATE EXTENSION lantern;

      CREATE TABLE small_world (id integer, vector real[3]);
      INSERT INTO small_world (id, vector) VALUES (0, '{0,0,0}'), (1, '{0,0,1}');

      CREATE INDEX ON small_world USING lantern_hnsw (vector dist_l2sq_ops)
      WITH (M=2, ef_construction=10, ef=4, dim=3);
    '';
  };

  meta = {
    # PostgreSQL 18 support issue upstream: https://github.com/lanterndata/lantern/issues/375
    # Check after next package update.
    broken = lib.warnIf (
      finalAttrs.version != "0.5.0"
    ) "Is postgresql18Packages.lantern still broken?" (lib.versionAtLeast postgresql.version "18");
    description = "PostgreSQL vector database extension for building AI applications";
    homepage = "https://lantern.dev/";
    changelog = "https://github.com/lanterndata/lantern/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
  };
})
