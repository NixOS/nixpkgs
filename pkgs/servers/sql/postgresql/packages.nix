self: super: {

    pg_repack = super.callPackage ./pg_repack { };

    pg_similarity = super.callPackage ./pg_similarity { };

    pgroonga = super.callPackage ./pgroonga { };

    plv8 = super.callPackage ./plv8 {
        v8 = super.callPackage ../../../development/libraries/v8/plv8_6_x.nix {
            python = self.python2;
        };
    };

    pgjwt = super.callPackage ./pgjwt { };

    cstore_fdw = super.callPackage ./cstore_fdw { };

    pg_hll = super.callPackage ./pg_hll { };

    pg_cron = super.callPackage ./pg_cron { };

    pg_topn = super.callPackage ./topn { };

    pgtap = super.callPackage ./pgtap { };

    timescaledb = super.callPackage ./timescaledb { };

    tsearch_extras = super.callPackage ./tsearch_extras { };
}