{ lib
, stdenv
, cmake
, fetchFromGitHub
, postgresql
, postgresqlTestExtension
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "postgresql-lantern";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "lanterndata";
    repo = "lantern";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d5CdS11Z0u8+oPvjH6gVx6k8y05SS6wU3PnafcEgQeY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    postgresql
  ];

  installPhase = ''
    runHook preInstall

    install -D -t $out/lib lantern${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension lantern-*.sql
    install -D -t $out/share/postgresql/extension lantern.control

    runHook postInstall
  '';

  cmakeFlags = [
    "-DBUILD_FOR_DISTRIBUTING=ON"
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

  meta = with lib; {
    description = "PostgreSQL vector database extension for building AI applications";
    homepage = "https://lantern.dev/";
    changelog = "https://github.com/lanterndata/lantern/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.bsl11;
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    # error: use of undeclared identifier 'aligned_alloc'
    broken = stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13";
  };
})
