{
  buildPgrxExtension,
  cargo-pgrx_0_18_0,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
  postgresqlTestExtension,
}:
buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_18_0;

  pname = "pglite_fusion";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "frectonz";
    repo = "pglite-fusion";
    tag = finalAttrs.version;
    hash = "sha256-/BUA3bxp/5di6R574VtAaWqhMWrJYyt2Me3pMBtk76s=";
  };

  cargoHash = "sha256-954nNwdMDE9tVOvql/fMR8J1pIq64AdKiKlBjl0yqRI=";

  # pgrx tests try to install the extension into the postgresql nix store
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    sql = ''
      CREATE EXTENSION pglite_fusion;

      CREATE TABLE people (
        name     TEXT NOT NULL,
        database SQLITE DEFAULT init_sqlite($sqlite$CREATE TABLE todos (task TEXT)$sqlite$)
      );

      INSERT INTO people VALUES ('frectonz');

      UPDATE people
      SET database = execute_sqlite(
        database,
        $sqlite$INSERT INTO todos VALUES ('solve multitenancy')$sqlite$
      )
      WHERE name = 'frectonz';
    '';
    asserts = [
      {
        query = ''
          SELECT get_sqlite_text(sqlite_row, 0)
          FROM query_sqlite(
            (SELECT database FROM people WHERE name = 'frectonz'),
            'SELECT * FROM todos'
          )
        '';
        expected = "'solve multitenancy'";
        description = "todo stored in the embedded SQLite database can be read back";
      }
    ];
  };

  meta = {
    description = "PostgreSQL extension for embedding an SQLite database in a column";
    homepage = "https://github.com/frectonz/pglite-fusion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frectonz ];
    platforms = postgresql.meta.platforms;
  };
})
