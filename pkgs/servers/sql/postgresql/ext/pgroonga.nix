{
  fetchFromGitHub,
  groonga,
  lib,
  meson,
  msgpack-c,
  ninja,
  pkg-config,
  postgresql,
  postgresqlBuildExtension,
  ruby,
  stdenvNoCC,
  xxhash,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgroonga";
  version = "4.0.9";

  src = fetchFromGitHub {
    owner = "pgroonga";
    repo = "pgroonga";
    tag = finalAttrs.version;
    hash = "sha256-ADHrHCUrpu5aCAU84QyLkmDDJ6QwICLsL6M8o/OMWxU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    msgpack-c
    groonga
    xxhash
  ];

  mesonFlags = [
    (lib.mesonEnable "message_pack" true)
    # tests need pgroonga installed on a running server, run in passthru.tests.regression
    (lib.mesonBool "test" false)
  ];

  # postgresqlBuildExtension moves files out of DESTDIR in postInstall
  mesonInstallFlags = [ "--destdir=${placeholder "out"}" ];

  passthru.tests.regression = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-regression";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [ ruby ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      patchShebangs test/short-pgappname
      ruby test/prepare.rb schedule
      # the expected parallel plan depends on the planner's index size estimate
      sed -i '/declarative-partitioning\/builtin/d' schedule
      # fails intermittently
      sed -i '/function\/wal-apply\/delete$/d' schedule

      ${lib.getDev postgresql}/lib/pgxs/src/test/regress/pg_regress \
        --bindir=${postgresql.withPackages (_: [ finalAttrs.finalPackage ])}/bin \
        --inputdir=. \
        --outputdir=. \
        --temp-instance=./tmp_check \
        --encoding=UTF8 \
        --launcher=test/short-pgappname \
        --load-extension=pgroonga \
        --schedule=schedule

      runHook postBuild
    '';

    installPhase = "touch $out";
  };

  meta = {
    description = "PostgreSQL extension to use Groonga as the index";
    longDescription = ''
      PGroonga is a PostgreSQL extension to use Groonga as the index.
      PostgreSQL supports full text search against languages that use only alphabet and digit.
      It means that PostgreSQL doesn't support full text search against Japanese, Chinese and so on.
      You can use super fast full text search feature against all languages by installing PGroonga into your PostgreSQL.
    '';
    homepage = "https://pgroonga.github.io/";
    changelog = "https://github.com/pgroonga/pgroonga/releases/tag/${finalAttrs.version}";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with lib.maintainers; [
      DerTim1
      anish
    ];
  };
})
