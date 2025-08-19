self:
let
  # Before removing an EOL major version, make sure to check the versioning policy in:
  # <nixpkgs>/nixos/modules/services/databases/postgresql.md
  #
  # Before removing, make sure to update it to the last minor version - and if only in
  # an immediately preceding commit. This allows people relying on that old major version
  # for a bit longer to still update up to this commit to at least get the latest minor
  # version. In other words: Do not remove the second-to-last minor version from nixpkgs,
  # yet. Update first.
  versions = {
    postgresql_13 = ./13.nix;
    postgresql_14 = ./14.nix;
    postgresql_15 = ./15.nix;
    postgresql_16 = ./16.nix;
    postgresql_17 = ./17.nix;
    postgresql_18 = ./18.nix;
  };

  mkAttributes =
    jitSupport:
    self.lib.mapAttrs' (
      version: path:
      let
        attrName = if jitSupport then "${version}_jit" else version;
        postgresql = import path { inherit self; };
        attrValue = if jitSupport then postgresql.withJIT else postgresql.withoutJIT;
      in
      self.lib.nameValuePair attrName attrValue
    ) versions;

  libpq = self.callPackage ./libpq.nix { };

in
{
  # variations without and with JIT
  postgresqlVersions = mkAttributes false;
  postgresqlJitVersions = mkAttributes true;

  inherit libpq;
}
