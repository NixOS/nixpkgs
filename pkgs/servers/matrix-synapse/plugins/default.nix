{ callPackage }:

{
  matrix-http-rendezvous-synapse = callPackage ./rendezvous.nix { };
  matrix-synapse-ldap3 = callPackage ./ldap3.nix { };
  matrix-synapse-mjolnir-antispam = callPackage ./mjolnir-antispam.nix { };
  matrix-synapse-pam = callPackage ./pam.nix { };
  matrix-synapse-shared-secret-auth = callPackage ./shared-secret-auth.nix { };
}
