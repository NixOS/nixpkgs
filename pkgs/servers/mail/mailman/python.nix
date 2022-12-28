{ python3 }:

python3.override {
  packageOverrides = self: super: {
    # does not find tests
    alembic = super.alembic.overridePythonAttrs (oldAttrs:  {
      doCheck = false;
    });
    # Needed by mailman, see https://gitlab.com/mailman/mailman/-/issues/964
    sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
      version = "1.3.24";
      src = super.fetchPypi {
        inherit version;
        inherit (oldAttrs) pname;
        sha256 = "06bmxzssc66cblk1hamskyv5q3xf1nh1py3vi6dka4lkpxy7gfzb";
      };
      # does not find tests
      doCheck = false;
    });
    # Fixes `AssertionError: database connection isn't set to UTC`
    psycopg2 = super.psycopg2.overridePythonAttrs (a: (rec {
      version = "2.8.6";
      src = super.fetchPypi {
        inherit version;
        inherit (a) pname;
        sha256 = "fb23f6c71107c37fd667cb4ea363ddeb936b348bbd6449278eb92c189699f543";
      };
    }));
  };
}
