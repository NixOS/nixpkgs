self: super: {

    age = super.callPackage ./ext/age.nix { };

    periods = super.callPackage ./ext/periods.nix { };

    postgis = super.callPackage ./ext/postgis.nix { };

    pg_auto_failover = super.callPackage ./ext/pg_auto_failover.nix { };

    pg_bigm = super.callPackage ./ext/pg_bigm.nix { };

    pg_ed25519 = super.callPackage ./ext/pg_ed25519.nix { };

    pg_rational = super.callPackage ./ext/pg_rational.nix { };

    pg_repack = super.callPackage ./ext/pg_repack.nix { };

    pg_similarity = super.callPackage ./ext/pg_similarity.nix { };

    pgroonga = super.callPackage ./ext/pgroonga.nix { };

    pgvector = super.callPackage ./ext/pgvector.nix { };

    plpgsql_check = super.callPackage ./ext/plpgsql_check.nix { };

    plr = super.callPackage ./ext/plr.nix { };

    plv8 = super.callPackage ./ext/plv8.nix {
        v8 = super.callPackage ../../../development/libraries/v8/plv8_6_x.nix {
            python = self.python2;
        };
    };

    pgjwt = super.callPackage ./ext/pgjwt.nix { };

    cstore_fdw = super.callPackage ./ext/cstore_fdw.nix { };

    pg_hll = super.callPackage ./ext/pg_hll.nix { };

    pg_cron = super.callPackage ./ext/pg_cron.nix { };

    pg_topn = super.callPackage ./ext/pg_topn.nix { };

    pgtap = super.callPackage ./ext/pgtap.nix { };

    pipelinedb = super.callPackage ./ext/pipelinedb.nix { };

    smlar = super.callPackage ./ext/smlar.nix { };

    temporal_tables = super.callPackage ./ext/temporal_tables.nix { };

    timescaledb = super.callPackage ./ext/timescaledb.nix { };

    tsearch_extras = super.callPackage ./ext/tsearch_extras.nix { };

    tds_fdw = super.callPackage ./ext/tds_fdw.nix { };

    pgrouting = super.callPackage ./ext/pgrouting.nix { };

    pg_partman = super.callPackage ./ext/pg_partman.nix { };

    pg_safeupdate = super.callPackage ./ext/pg_safeupdate.nix { };

    repmgr = super.callPackage ./ext/repmgr.nix { };
}
