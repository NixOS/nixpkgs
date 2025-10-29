{
  python3,
  lib,
  overlay ? (_: _: { }),
}:

lib.fix (
  self:
  python3.override {
    inherit self;
    packageOverrides =
      lib.composeExtensions
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

          django-allauth = super.django-allauth.overrideAttrs (
            new:
            { src, ... }:
            {
              version = "0.63.6";
              src = src.override {
                tag = new.version;
                hash = "sha256-13/QbA//wyHE9yMB7Jy/sJEyqPKxiMN+CZwSc4U6okU=";
              };
              patches = [ ];
            }
          );
        })

        overlay;
  }
)
