{ python3, fetchPypi, lib, overlay ? (_: _: {}) }:

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
      elasticsearch = super.elasticsearch.overridePythonAttrs ({ pname, ... }: rec {
        version = "7.17.9";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-ZsTs4q3+fMEg4rameYof1cd3rs+C7sObuVzvfPx+orM=";
        };
      });

      # https://gitlab.com/mailman/hyperkitty/-/merge_requests/541
      mistune = super.mistune.overridePythonAttrs (old: rec {
        version = "2.0.5";
        src = fetchPypi {
          inherit (old) pname;
          inherit version;
          hash = "sha256-AkYRPLJJLbh1xr5Wl0p8iTMzvybNkokchfYxUc7gnTQ=";
        };
      });

      # django-q tests fail with redis 5.0.0.
      redis = super.redis.overridePythonAttrs ({ pname, ... }: rec {
        version = "4.5.4";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-c+w12k2iZ9aEfkf2hzD91fYuLKaePvWIXGp4qTdMOJM=";
        };
      });
    })

    overlay;
}
