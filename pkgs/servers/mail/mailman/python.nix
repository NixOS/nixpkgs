<<<<<<< HEAD
{ python3, lib, overlay ? (_: _: {}) }:

python3.override {
  packageOverrides = lib.composeExtensions
    (self: super: {
      /*
        This overlay can be used whenever we need to override
        dependencies specific to the mailman ecosystem: in the past
        this was necessary for e.g. psycopg2[1] or sqlalchemy[2].

        In such a large ecosystem this sort of issue is expected
        to arise again. Since we don't want to clutter the python package-set
        itself with version overrides and don't want to change the APIs
        in here back and forth every time this comes up (and as a result
        force users to change their code accordingly), this overlay
        is kept on purpose, even when empty.

        [1] 72a14ea563a3f5bf85db659349a533fe75a8b0ce
        [2] f931bc81d63f5cfda55ac73d754c87b3fd63b291
      */
      django = super.django_3;
    })

    overlay;
=======
{ python3 }:

python3.override {
  packageOverrides = self: super: {
    # does not find tests
    alembic = super.alembic.overridePythonAttrs (oldAttrs: {
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
