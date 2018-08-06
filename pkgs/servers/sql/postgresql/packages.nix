{ pkgs, lib }:

let
  postgresqlPackages = pkgs.callPackages ./default.nix {};

  # Filter out any versions which fail a version check.
  filterPackages = lib.filterAttrs (_: drv: drv.versionCheck or true);

  makePackageSet = postgresql:
    let
      callPackage = p: args: pkgs.callPackage p (args // { inherit postgresql; });
    in
    filterPackages {
      # Convenience function for end-users to easily build packages against a specific
      # version.
      inherit callPackage;

      # Convenience function for top-level attributes that were previously available,
      # but are deprecated and renamed. TODO FIXME: remove this after 18.09 is released.
      # see all-packages.nix (in the postgresql section) for more
      callPackageWithDeprecation = name: p: args:
        builtins.trace ''
          The PostgreSQL-related attribute '${name}' is deprecated. Please use the
          'postgresqlPackages.${name}' attribute instead (to use the default version of
          PostgreSQL in Nixpkgs), or use 'postgresql<XX>Packages.${name}' for a given
          version <XX>.
        '' (callPackage p args);

      # Convenience attribute that exports the postgres derivation used for builds. We
      # export these from all-packages.nix to consolidate everything here.
      inherit postgresql;

      # PostgreSQL extensions follow from here.

      cstore_fdw = callPackage ./ext/cstore_fdw.nix {};

      postgis = callPackage ./ext/postgis.nix {};

      pg_cron = callPackage ./ext/pg_cron.nix {};

      pg_hll = callPackage ./ext/pg_hll.nix {};

      pgjwt = callPackage ./ext/pgjwt.nix {};

      pg_jobmon = callPackage ./ext/pg_jobmon.nix {};

      pg_partman = callPackage ./ext/pg_partman.nix {};

      pg_repack = callPackage ./ext/pg_repack.nix {};

      pgroonga = callPackage ./ext/pgroonga.nix {};

      pg_similarity = callPackage ./ext/pg_similarity.nix {};

      pgtap = callPackage ./ext/pgtap.nix {};

      pg_topn = callPackage ./ext/pg_topn.nix {};

      plv8 = callPackage ./ext/plv8.nix {
        v8 = pkgs.v8_6_x;
      };

      timescaledb = callPackage ./ext/timescaledb.nix {};

      tsearch_extras = callPackage ./ext/tsearch_extras.nix { };
    };
in
with postgresqlPackages; {
  postgresql93Packages = makePackageSet postgresql93;
  postgresql94Packages = makePackageSet postgresql94;
  postgresql95Packages = makePackageSet postgresql95;
  postgresql96Packages = makePackageSet postgresql96;
  postgresql10Packages = makePackageSet postgresql10;
}
