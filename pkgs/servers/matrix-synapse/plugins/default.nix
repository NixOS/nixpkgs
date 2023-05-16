{ callPackage }:

{
  matrix-http-rendezvous-synapse = callPackage ./rendezvous.nix { };
  matrix-synapse-ldap3 = callPackage ./ldap3.nix { };
  matrix-synapse-mjolnir-antispam = callPackage ./mjolnir-antispam.nix { };
  matrix-synapse-pam = callPackage ./pam.nix { };
<<<<<<< HEAD
  matrix-synapse-s3-storage-provider = callPackage ./s3-storage-provider.nix { };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  matrix-synapse-shared-secret-auth = callPackage ./shared-secret-auth.nix { };
}
