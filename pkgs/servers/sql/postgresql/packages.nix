self: super: {

    age = super.callPackage ./ext/age.nix { };

    apache_datasketches = super.callPackage ./ext/apache_datasketches.nix { };

    citus = super.callPackage ./ext/citus.nix { };

    h3-pg = super.callPackage ./ext/h3-pg.nix { };

    hypopg = super.callPackage ./ext/hypopg.nix { };

    jsonb_deep_sum = super.callPackage ./ext/jsonb_deep_sum.nix { };

    periods = super.callPackage ./ext/periods.nix { };

    postgis = super.callPackage ./ext/postgis.nix { };

    pg_auto_failover = super.callPackage ./ext/pg_auto_failover.nix { };

    pg_bigm = super.callPackage ./ext/pg_bigm.nix { };

    pg_ed25519 = super.callPackage ./ext/pg_ed25519.nix { };

    pg_embedding = super.callPackage ./ext/pg_embedding.nix { };

    pg_hint_plan = super.callPackage ./ext/pg_hint_plan.nix { };

    pg_ivm = super.callPackage ./ext/pg_ivm.nix { };

    pg_rational = super.callPackage ./ext/pg_rational.nix { };

    pg_repack = super.callPackage ./ext/pg_repack.nix { };

    pg_similarity = super.callPackage ./ext/pg_similarity.nix { };

    pgaudit = super.callPackage ./ext/pgaudit.nix { };

    pgroonga = super.callPackage ./ext/pgroonga.nix { };

    pgsql-http = super.callPackage ./ext/pgsql-http.nix { };

    pgvector = super.callPackage ./ext/pgvector.nix { };

    plpgsql_check = super.callPackage ./ext/plpgsql_check.nix { };

    plr = super.callPackage ./ext/plr.nix { };

    plv8 = super.callPackage ./ext/plv8 { };

    pgjwt = super.callPackage ./ext/pgjwt.nix { };

    cstore_fdw = super.callPackage ./ext/cstore_fdw.nix { };

    pg_hll = super.callPackage ./ext/pg_hll.nix { };

    pg_cron = super.callPackage ./ext/pg_cron.nix { };

    pg_topn = super.callPackage ./ext/pg_topn.nix { };

    pg_net = super.callPackage ./ext/pg_net.nix { };

    pgtap = super.callPackage ./ext/pgtap.nix { };

    smlar = super.callPackage ./ext/smlar.nix { };

    temporal_tables = super.callPackage ./ext/temporal_tables.nix { };

    timescaledb = super.callPackage ./ext/timescaledb.nix { };
    timescaledb-apache = super.callPackage ./ext/timescaledb.nix { enableUnfree = false; };

    timescaledb_toolkit = super.callPackage ./ext/timescaledb_toolkit.nix { };

    tsearch_extras = super.callPackage ./ext/tsearch_extras.nix { };

    tds_fdw = super.callPackage ./ext/tds_fdw.nix { };

    pgrouting = super.callPackage ./ext/pgrouting.nix { };

    pg_partman = super.callPackage ./ext/pg_partman.nix { };

    pg_relusage = super.callPackage ./ext/pg_relusage.nix { };

    pg_safeupdate = super.callPackage ./ext/pg_safeupdate.nix { };

    pg_uuidv7 = super.callPackage ./ext/pg_uuidv7.nix { };

    promscale_extension = super.callPackage ./ext/promscale_extension.nix { };

    repmgr = super.callPackage ./ext/repmgr.nix { };

    rum = super.callPackage ./ext/rum.nix { };

    tsja = super.callPackage ./ext/tsja.nix { };

    wal2json = super.callPackage ./ext/wal2json.nix { };
}
