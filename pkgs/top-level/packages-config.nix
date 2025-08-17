# Used in the generation of package search database.
{
  # Ensures no aliases are in the results.
  allowAliases = false;

  # Remove Packages sets that we don't want to have appear on search.nixos.org and the index.
  packageOverrides =
    super: with super; {
      # minimal-bootstrap packages aren't used for anything but bootstrapping our
      # stdenv. They should not be used for any other purpose and therefore not
      # show up in search results or repository tracking services that consume our
      # packages.json https://github.com/NixOS/nixpkgs/issues/244966
      minimal-bootstrap = { };

      # This makes it so that tests are not appering on search.nixos.org
      tests = { };
    };
}
