{ lib
, stdenv
, fetchFromGitHub
, perl
, perlPackages
, postgresql
, postgresqlTestHook
, which
}:

stdenv.mkDerivation rec {
  pname = "pgtap";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "theory";
    repo = "pgtap";
    rev = "v${version}";
    sha256 = "sha256-HOgCb1CCfsfbMbMMWuzFJ4B8CfVm9b0sI2zBY3/kqyI=";
  };

  nativeBuildInputs = [ postgresql perl perlPackages.TAPParserSourceHandlerpgTAP which ];

  installPhase = ''
    install -D src/pgtap.so -t $out/lib
    install -D {sql/pgtap--${version}.sql,pgtap.control} -t $out/share/postgresql/extension
  '';

  passthru.tests.extension = stdenv.mkDerivation {
    name = "pgtap-test";
    dontUnpack = true;
    doCheck = true;
    buildInputs = [ postgresqlTestHook ];
    nativeCheckInputs = [ (postgresql.withPackages (ps: [ ps.pgtap ])) ];
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
    passAsFile = [ "sql" ];
    sql = ''
      CREATE EXTENSION pgtap;

      BEGIN;
      SELECT plan(1);
      SELECT pass('Test passed');
      SELECT * FROM finish();
      ROLLBACK;
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
    description = "A unit testing framework for PostgreSQL";
    longDescription = ''
      pgTAP is a unit testing framework for PostgreSQL written in PL/pgSQL and PL/SQL.
      It includes a comprehensive collection of TAP-emitting assertion functions,
      as well as the ability to integrate with other TAP-emitting test frameworks.
      It can also be used in the xUnit testing style.
    '';
    maintainers = with maintainers; [ willibutz ];
    homepage = "https://pgtap.org";
    inherit (postgresql.meta) platforms;
    license = licenses.mit;
  };
}
