{
  newScope,
  lib,
<<<<<<< HEAD
  python312,
=======
  python3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

let
  self = lib.makeExtensible (
    self:
    let
      inherit (self) callPackage;
    in
    {
      callPackage = newScope self;

<<<<<<< HEAD
      python3 = callPackage ./python.nix { python3 = python312; };
=======
      python3 = callPackage ./python.nix { inherit python3; };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

      hyperkitty = callPackage ./hyperkitty.nix { };

      mailman = callPackage ./package.nix { };

      mailman-hyperkitty = callPackage ./mailman-hyperkitty.nix { };

      postorius = callPackage ./postorius.nix { };

      web = callPackage ./web.nix { };

      buildEnvs =
        {
          web ? self.web,
          mailman ? self.mailman,
          mailman-hyperkitty ? self.mailman-hyperkitty,
          withHyperkitty ? false,
          withLDAP ? false,
        }:
        {
          mailmanEnv = self.python3.withPackages (
            ps:
            [
              mailman
              ps.psycopg2
            ]
            ++ lib.optional withHyperkitty mailman-hyperkitty
            ++ lib.optionals withLDAP [
              ps.python-ldap
              ps.django-auth-ldap
            ]
          );
          webEnv = self.python3.withPackages (
            ps:
            [
              web
              ps.psycopg2
            ]
            ++ lib.optionals withLDAP [
              ps.python-ldap
              ps.django-auth-ldap
            ]
          );
        };
    }
  );

in
self
