self: super:
let
  inherit (self) lib config;
in
(lib.packagesFromDirectoryRecursive {
  inherit (super) callPackage;
  directory = ./ext;
})
// {
  inherit (super) callPackage;

  timescaledb-apache = super.callPackage ./ext/timescaledb.nix { enableUnfree = false; };
}
// lib.optionalAttrs (!self.perlSupport) {
  plperl = throw "PostgreSQL extension `plperl` is not available, because `postgresql` was built without Perl support. Override with `perlSupport = true` to enable the extension.";
}
// lib.optionalAttrs (!self.pythonSupport) {
  plpython3 = throw "PostgreSQL extension `plpython3` is not available, because `postgresql` was built without Python support. Override with `pythonSupport = true` to enable the extension.";
}
// lib.optionalAttrs (!self.tclSupport) {
  pltcl = throw "PostgreSQL extension `pltcl` is not available, because `postgresql` was built without Tcl support. Override with `tclSupport = true` to enable the extension.";
}
// lib.optionalAttrs config.allowAliases {
  pg_embedding = throw "PostgreSQL extension `pg_embedding` has been removed since the project has been abandoned. Upstream's recommendation is to use pgvector instead (https://neon.tech/docs/extensions/pg_embedding#migrate-from-pg_embedding-to-pgvector)";
}
