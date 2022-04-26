{ newScope, lib, python3 }:

let
  callPackage = newScope self;

  self = lib.makeExtensible (self: {
    python3 = callPackage ./python.nix { inherit python3; };

    hyperkitty = callPackage ./hyperkitty.nix { };

    mailman = callPackage ./package.nix { };

    mailman-hyperkitty = callPackage ./mailman-hyperkitty.nix { };

    postorius = callPackage ./postorius.nix { };

    web = callPackage ./web.nix { };

    buildEnv = { web ? self.web
               , mailman ? self.mailman
               , mailman-hyperkitty ? self.mailman-hyperkitty
               , withHyperkitty ? false
               }:
      self.python3.withPackages
        (ps:
          [ web mailman ps.psycopg2 ]
          ++ lib.optional withHyperkitty mailman-hyperkitty);
  });

in self
