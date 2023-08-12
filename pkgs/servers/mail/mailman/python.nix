{ python3, lib, overlay ? (_: _: {}) }:

python3.override {
  packageOverrides = lib.composeExtensions
    (self: super: {
      # does not find tests
      alembic = super.alembic.overridePythonAttrs (oldAttrs: {
        doCheck = false;
      });
    })
    overlay;
}
