{ callPackage }:

{
  matrix-synapse-ldap3 = callPackage ./ldap3.nix { };
  matrix-synapse-pam = callPackage ./pam.nix { };
  matrix-synapse-rest-password-provider = callPackage ./rest-password-provider.nix { };
}
