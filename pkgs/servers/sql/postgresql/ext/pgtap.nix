{
  fetchFromGitHub,
  lib,
  perl,
  perlPackages,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestHook,
  stdenv,
  which,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pgtap";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "theory";
    repo = "pgtap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YgvfLGF7pLVcCKD66NnWAydDxtoYHH1DpLiYTEKHJ0E=";
  };

  nativeBuildInputs = [
    perl
    perlPackages.TAPParserSourceHandlerpgTAP
    which
  ];

  passthru.tests.extension = stdenv.mkDerivation {
    name = "pgtap-test";
    dontUnpack = true;
    doCheck = true;
    nativeCheckInputs = [
      postgresqlTestHook
      (postgresql.withPackages (_: [ finalAttrs.finalPackage ]))
    ];
    passAsFile = [ "sql" ];
    sql = ''
      CREATE EXTENSION pgtap;

      BEGIN;
      SELECT plan(1);
      SELECT pass('Test passed');
      SELECT * FROM finish();
      ROLLBACK;
    '';
    checkPhase = ''
      runHook preCheck
      psql -a -v ON_ERROR_STOP=1 -f $sqlPath
      runHook postCheck
    '';
    installPhase = "touch $out";
  };

  meta = {
    description = "Unit testing framework for PostgreSQL";
    longDescription = ''
      pgTAP is a unit testing framework for PostgreSQL written in PL/pgSQL and PL/SQL.
      It includes a comprehensive collection of TAP-emitting assertion functions,
      as well as the ability to integrate with other TAP-emitting test frameworks.
      It can also be used in the xUnit testing style.
    '';
    maintainers = [ ];
    homepage = "https://pgtap.org";
    inherit (postgresql.meta) platforms;
    license = lib.licenses.mit;
  };
})
