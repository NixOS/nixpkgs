{ lib
, stdenv
, cmake
, fetchFromGitHub
, openssl
, postgresql
, postgresqlTestHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "postgresql-lantern";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "lanterndata";
    repo = "lantern";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V8W61hELXeaVvNZgRUcckFlCMWis7NENlRKySxsK/L8=";
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
    "-S ../lantern_hnsw"
  ];

  passthru.tests.extension = stdenv.mkDerivation {
    name = "lantern-pg-test";
    dontUnpack = true;
    doCheck = true;
    buildInputs = [ postgresqlTestHook ];
    nativeCheckInputs = [ (postgresql.withPackages (_: [ finalAttrs.finalPackage ])) ];
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    passAsFile = [ "sql" ];
    sql = ''
      CREATE EXTENSION lantern;

      CREATE TABLE small_world (id integer, vector real[3]);
      INSERT INTO small_world (id, vector) VALUES (0, '{0,0,0}'), (1, '{0,0,1}');

      CREATE INDEX ON small_world USING hnsw (vector dist_l2sq_ops)
      WITH (M=2, ef_construction=10, ef=4, dim=3);
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
    description = "PostgreSQL vector database extension for building AI applications";
    homepage = "https://lantern.dev/";
    changelog = "https://github.com/lanterndata/lantern/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.bsl11;
    maintainers = [ ];
    platforms = postgresql.meta.platforms;
    # error: use of undeclared identifier 'aligned_alloc'
    broken = stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13";
  };
})
