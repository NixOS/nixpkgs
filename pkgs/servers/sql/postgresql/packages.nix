self: super: {

    postgis = super.callPackage ./ext/postgis.nix {
        gdal = self.gdal.override {
            postgresql = self.postgresql;
            poppler = self.poppler_0_61;
        };
    };

    pg_repack = super.callPackage ./ext/pg_repack.nix { };

    pg_similarity = super.callPackage ./ext/pg_similarity.nix { };

    pgroonga = super.callPackage ./ext/pgroonga.nix { };

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

    timescaledb = super.callPackage ./ext/timescaledb.nix { };

    tsearch_extras = super.callPackage ./ext/tsearch_extras.nix { };

    tds_fdw = super.callPackage ./ext/tds_fdw.nix { };

    pgrouting = super.callPackage ./ext/pgrouting.nix { };

    pg_partman = super.callPackage ./ext/pg_partman.nix { };
}
