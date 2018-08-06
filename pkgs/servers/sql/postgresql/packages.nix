{ pkgs, lib }:

let
  llvmPackages = pkgs.llvmPackages_6;
  postgresqlPackages = pkgs.callPackages ./default.nix { inherit llvmPackages; };

  # Filter out any versions which fail a version check.
  filterPackages = lib.filterAttrs (_: drv: drv.versionCheck or true);

  # Build an environment containing PostgreSQL, its libraries, and any paths
  # containing binary-compatible installed plugins.
  withPackages = postgresql: plugins:
    if plugins == []
    then postgresql
    else pkgs.buildEnv {
      name = "postgresql-and-plugins-${postgresql.version}";
      paths = [ postgresql postgresql.lib ] ++ plugins;

      # We include /bin to ensure the $out/bin directory is created, which is
      # needed because we'll be removing the files from that directory in postBuild
      # below. See #22653
      pathsToLink = ["/" "/bin"];

      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        mkdir -p $out/bin
        rm $out/bin/{pg_config,postgres,pg_ctl}
        cp --target-directory=$out/bin ${postgresql}/bin/{postgres,pg_config,pg_ctl}
        wrapProgram $out/bin/postgres --set NIX_PGLIBDIR $out/lib
      '';
    };

  # This is the same as above, but a bit more spicy: it takes a postgres
  # package set and a continuation, which determines which extensions to use in
  # the resulting environment. This is the analog of the NixOS module's method
  # for selecting compatible plugins -- incompatible plugins will not exist in
  # the attrset, resulting in an evaluation error.
  withPackageSet = ps: k: withPackages ps.postgresql (k ps);

  makePackageSet = postgresql:
    let
      stdenv = postgresql.stdenv; # Use the stdenv for the particular version of Postgres
      callPackage = p: args: pkgs.callPackage p (args // { inherit postgresql stdenv; });

      self = filterPackages {
        # Convenience function for end-users to easily build packages against a specific
        # version.
        inherit callPackage;

        # Convenience function for getting a full PostgreSQL derivation with extensions
        # for the given version.
        withPackages = withPackageSet self;

        # Convenience attribute that exports the postgres derivation used for builds. We
        # export these from all-packages.nix to consolidate everything here.
        inherit postgresql;

        # PostgreSQL extensions follow from here.

        citus = callPackage ./ext/citus.nix {};

        cstore_fdw = callPackage ./ext/cstore_fdw.nix {};

        pg_cron = callPackage ./ext/pg_cron.nix {};

        pg_hll = callPackage ./ext/pg_hll.nix {};

        pgjwt = callPackage ./ext/pgjwt.nix {};

        pg_jobmon = callPackage ./ext/pg_jobmon.nix {};

        pg_journal = callPackage ./ext/pg_journal.nix {};

        pg_partman = callPackage ./ext/pg_partman.nix {};

        pg_repack = callPackage ./ext/pg_repack.nix {};

        pgroonga = callPackage ./ext/pgroonga.nix {};

        pg_similarity = callPackage ./ext/pg_similarity.nix {};

        pgtap = callPackage ./ext/pgtap.nix {};

        pg_topn = callPackage ./ext/pg_topn.nix {};

        plv8 = callPackage ./ext/plv8.nix {
          v8 = pkgs.v8_6_x;
        };

        postgis = callPackage ./ext/postgis.nix {};

        timescaledb = callPackage ./ext/timescaledb.nix {};

        tsearch_extras = callPackage ./ext/tsearch_extras.nix { };
      };
    in self;
in
with postgresqlPackages; {
  postgresql93Packages = makePackageSet postgresql93;
  postgresql94Packages = makePackageSet postgresql94;
  postgresql95Packages = makePackageSet postgresql95;
  postgresql96Packages = makePackageSet postgresql96;
  postgresql10Packages = makePackageSet postgresql10;
  postgresql11Packages = makePackageSet postgresql11;

  # HEADS UP: do NOT export this from the top level of all-packages.nix!
  # it is only used by the NixOS module for PostgreSQL in order to reduce
  # some of the duplicated logic needed for withPackages. this should
  # _only_ be used by postgresql.nix, and nothing more. Do not taunt
  # Happy Fun Ball.
  inherit withPackages;
}
